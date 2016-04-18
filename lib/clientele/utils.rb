require "clientele/utils/version"

module Clientele
  module Utils
    
    module URI; module_function
      
      def uri_to_hash(uri)
        uri = URI.parse URI unless uri.is_a? URI
        scheme, userinfo, host, port, registry, path, opaque, query, fragment = uri.split
        {
          root: uri_class(scheme).build(scheme, userinfo, host, port, registry),
          path: path_to_string(path),
          query: query_to_hash(query),
        }
      end
      
      def uri_class(scheme)
        URI.scheme_list[scheme.to_s.upcase] or URI::Generic
      end
      
      def query_to_hash(query)
        CGI::parse query
      end
      
      def path_to_string(path)
        CGI::unescape path
      end
      
    end

    module DeepCopy; module_function

      def initialize_copy(original)
        super
        instance_variables.each do |var|
          original_var = original.instance_variable_get(var)
          new_var = cloneable?(original_var) ? original_var.clone : original_var
          instance_variable_set var, new_var
        end
      end

    private

      def cloneable?(object)
        case object
        when NilClass, TrueClass, FalseClass, Symbol, Singleton
          false
        else; true; end
      end

    end

    module DeepFreeze; module_function

      def freeze
        super
        instance_variables.each do |var|
          instance_variable_get(var).freeze
        end
      end

    end

  end
end
