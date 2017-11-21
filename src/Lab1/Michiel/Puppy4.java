public class Puppy4 {
   int puppyAge;

   public Puppy4(String name) {
      // This constructor has one parameter, name.
      System.out.println("Name chosen is :" + name );
   }
   
   public static void main(String []args) {
      /* Object creation */
      Puppy3 myPuppy = new Puppy4( "tommy" );

      /* Call class method to set puppy's age */
      myPuppy.setAge( 2 );

      /* Call another class method to get puppy's age */
      myPuppy.getAge( );

      /* You can access instance variable as follows as well */
      System.out.println("Variable Value :" + myPuppy.puppyAge );
   }
}