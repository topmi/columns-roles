## Use for
To add simple roles feature to a model (like user) in a integer field.

## Install
include in Gemfile:

```bash
gem 'roles-field'
```

## Usage
in a model with a field named 'roles_mask' (you can use any other field name):

```ruby
# generate a model with a integer field
create_table :users, :force => true do |t|
  t.column :roles_mask, :integer
end

class User < ActiveRecord::Base
  # you can change to another field
  columns_roles :roles_mask, :roles => [:admin, :manager, :teacher, :student]
end
```

then

```ruby
@user.roles
# -> []

@user.role = :manager
@user.save
@user.roles
# -> [:manager]

@user.set_role :admin
@user.save
@user.roles
# -> [:admin]

@user.role? :admin
@user.is_admin?
# -> true

@user.role? :teacher
@user.is_teacher?
# -> false

@user.role
# -> :admin
# return user's first role

User.with_role :admin
# -> scope [...]
```

## TODO
to support multi-roles setting
