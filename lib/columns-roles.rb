# coding: utf-8
module ColumnsRoles
  module Base
    extend ActiveSupport::Concern
 
    module ClassMethods
      def columns_roles(column, options={})
        roles = options[:roles]
 
        class_eval %(
          def roles=(roles)
            self.#{column} = (#{roles} & roles).map { |role|
              2 ** #{roles}.index(role.to_sym)
            }.sum
          end

          def roles
            #{roles}.reject { |role|
              ((#{column} || 0 ) & 2 ** #{roles}.index(role.to_sym)).zero?
            }
          end

          def role?(role)
            self.roles.include? role.to_sym
          end

          def role
            self.roles[0]
          end

          def role=(role)
            self.roles = (#{roles} & [role.to_sym])
          end

          def set_role(role)
            self.role = role
          end

          scope :with_role, lambda{ |role|
            {
              :conditions => ['#{column} & ? > 0', 2 ** #{roles}.index(role.to_sym)]
            }
          }
        )
        roles.each{ |role|
          define_method "is_#{role}?" do
            role? role
          end
        }
      end
    end
  end
end

ActiveRecord::Base.send :include, ColumnsRoles::Base