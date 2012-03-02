## Knife plugin to set node Attributes
# http://wiki.opscode.com/display/chef/Attributes
#
## Install
# Place in .chef/plugins/knife/set_attributes.rb
#
# Javier Frias <jfrias@gmail.com>
#
#
# Based on set_environment.rb plugin by Nick Stielaus with input from Mailing list posts
#  Usage
# $ knife node set_attribute node.domain some_thing value_is 

require 'chef/knife'

module SomeNamespace
  class NodeSetAttribute < Chef::Knife

    deps do
      require 'chef/search/query'
      require 'chef/knife/search'
    end

    banner "knife node set_attribute NODE ATTRIBUTE ATTRIBUTE_VALUE"

    def run
      unless @node_name = name_args[0]
        ui.error "You need to specify a node"
        exit 1
      end

      unless @attribute = name_args[1]
        ui.error "You need to specify an attribute"
        exit 1
      end

      unless @value = name_args[2]
        ui.error "You need to specify an attribute value"
        exit 1
      end

      puts "Looking for #{@node_name}"

      searcher = Chef::Search::Query.new
      result = searcher.search(:node, "name:#{@node_name}")

      knife_search = Chef::Knife::Search.new
      node = result.first.first
      if node.nil?
        puts "Could not find a node named #{@node_name}"
        exit 1
      end

      puts "Setting attribute #{@attribute} to #{@value}"
      rb_cmd = "node." + @attribute + "=" + '"' + @value + '"'
      eval(rb_cmd)
      node.save

      knife_search = Chef::Knife::Search.new
      knife_search.name_args = ['node', "name:#{@node_name}"]
      knife_search.run

    end
  end
end
