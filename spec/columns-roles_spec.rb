# coding: utf-8
require "spec_helper"
require "db_init"

class TestMigration < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :manage, :integer
    end
  end

  def self.down
    drop_table  :users
  end
end

class User < ActiveRecord::Base
  columns_roles :manage, :roles => [:admin, :manager, :user, :test]
end

describe ColumnsRoles::Base do
  describe 'setting roles methods' do
    before(:all){TestMigration.up  }
    after(:all){TestMigration.down}

    before{
      @user = User.create
    }
    it '.roles' do
      @user.roles.should == []
    end

    it '.set_role' do
      @user.set_role :manager
      @user.role?(:manager).should == true
      @user.is_manager?.should == true

      @user.role?(:admin).should == false
      @user.is_admin?.should == false
    end

    describe '.role' do
      it {
        user = User.create
        user.role.should == nil
      }
      it {
        user = User.create :role => :user
        user.role.should == :user
      }
      it {
        user = User.create :role => :test
        user.role.should == :test
      }
    end
  end
  describe '查询方法' do
    before(:all) {TestMigration.up}
    after(:all) {TestMigration.down}

    before {
      [
        :admin, 
        :manager, :manager,
        :test, :test, :test,
        :user, :user, :user, :user
      ].each { |x|
        user = User.create(:role => x)
      }
    }
    it '.with_role' do
      User.with_role(:admin).count.should == 1
      User.with_role(:manager).count.should == 2
      User.with_role(:test).count.should == 3
      User.with_role(:user).count.should == 4
    end
  end
end










