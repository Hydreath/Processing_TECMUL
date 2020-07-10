import java.util.ArrayList;
import java.util.concurrent.ConcurrentLinkedQueue;

public class Pool<T extends IPoolable> {
    private ArrayList<T> inUse;
    private ConcurrentLinkedQueue<T> available;

    public Pool(){
        inUse = new ArrayList<T>();
        available = new ConcurrentLinkedQueue<T>();
    }

    public T get() throws Exception {
        T object = null;
        if(available.isEmpty()){
            throw new Exception();
        } else{
            object = available.poll();
        }
        push(object);
        return object;
    }

    public void release(T object){
        inUse.remove(object);
        available.add(object);
    }

    private void push(T object){
        inUse.add(object);
    }
    
    public void addObject(T object){
      available.add(object);
    }
    
    public T addAndRetrieveObject(T object){
      push(object);
      return object;
    }

}
