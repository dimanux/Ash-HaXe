package ash.core;

#if cpp
import cpp.FastIterator;
#end

class EntityListIterator #if cpp extends FastIterator<Entity> #end
{
    private var previous:Entity;
	private var pooled:Bool = false;
	private var nextPooled:EntityListIterator = null;
	private static var pool : Dynamic = null;

    public function new(head:Entity)
    {
		this.previous = head;
    }

    #if cpp override #end public function hasNext():Bool
    {
		if (pooled && (previous == null))
		{
			nextPooled = pool;
			pool = this;
			return false;
		}
		return previous != null;
    }

    #if cpp override #end public function next():Entity
    {
        var entity:Entity = previous;
        previous = entity.next;
        return entity;
    }
	
	public static function getFromPool(head:Entity) : EntityListIterator
	{
		if (pool == null)
		{
			var it : EntityListIterator = new EntityListIterator(head);
			it.pooled = true;
			return it;
		}
		else
		{
			var it : EntityListIterator = pool;
			pool = it.nextPooled;
			it.previous = head;
			it.nextPooled = null;
			return it;
		}
	}
}