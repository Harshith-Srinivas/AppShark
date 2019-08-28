public class samplefrui {
    public String fruits;
        
     public Pagereference test()
    {
        return null;
    }
    
    public List<SelectOption> getItems()
    {
		List<SelectOption> options = new List<SelectOption>();
        options.add(new Selectoption('MANGO','Mango'));
        options.add(new Selectoption('BANANA','Banana'));
        options.add(new Selectoption('Apple','Apple'));
        return options;
    }
    
    public String getFruits()
    {
        return fruits;
    }
    
    public void setFruits(String fruits)
    {
        this.fruits = fruits;
    }
    
    
}