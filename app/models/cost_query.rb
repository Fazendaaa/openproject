require_dependency "entry"

class CostQuery < ActiveRecord::Base
  #belongs_to :user
  #belongs_to :project
  #attr_protected :user_id, :project_id, :created_at, :updated_at

  def self.accepted_properties
    @accepted_properties ||= []
  end

  def results
    chain.results
  end

  def walker
    @walker ||= CostQuery::Walker.new self
  end

  ##
  # @see CostQuery::Walker#walk
  def walk(*args, &block)
    walker.walk(*args, &block)
  end

  def add_chain(type, name, options)
    chain type.const_get(name.to_s.camelcase), options
  end

  def chain(klass = nil, options = {})
    @walker = nil
    @chain ||= Filter::NoFilter.new
    @chain = klass.new @chain, options if klass
    @chain = @chain.parent until @chain.top?
    @chain
  end

  def filter(name, options = {})
    add_chain Filter, name, options
  end

  def group_by(name, options = {})
    add_chain GroupBy, name, options.reverse_merge(:type => :column)
  end

  def column(name, options = {})
    group_by name, options.merge(:type => :column)
  end

  def row(name, options = {})
    group_by name, options.merge(:type => :row)
  end

  def method_missing(*a, &b)
    chain.send(*a, &b)
  end

end;
