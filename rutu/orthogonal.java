import java.util.*;
class orthogonal
{
	public static void main(String ar[])
	{
		int a[]=new int[20];
		int b[]=new int[20];
		int c[]=new int[20];
		int n,sum=0,i;
		Scanner sc=new Scanner(System.in);
		System.out.println("Enter length of code");
		n=sc.nextInt();
		System.out.println("Enter first code:");
		for(i=0;i<n;i++)
		{
			a[i]=sc.nextInt();
			if(a[i]==0)
				a[i]=-1;
		}
	
		System.out.println("Enter second code:");
		for(i=0;i<n;i++)
		{
			b[i]=sc.nextInt();
			if(b[i]==0)
				b[i]=-1;
		}
		for(i=0;i<n;i++)
		{
			c[i]=a[i]*b[i];
			sum=sum+c[i];
		}
	/*	for(i=0;i<n;i++)
			System.out.println(c[i]+" ");
		System.out.println("Sum is: "+sum);   */
		if(sum==0)
			System.out.println("Codes are orthogonal");
		else
			System.out.println("Codes are not orthogonal");
	}
}
