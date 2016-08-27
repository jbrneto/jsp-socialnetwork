package utils;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


public class MD5Utils {
	public static String getMD5(String senha){
		try  {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(senha.getBytes());
			BigInteger hash = new BigInteger(1, md.digest());
			return hash.toString(16);
		}
		catch(NoSuchAlgorithmException ns)  {
			ns.printStackTrace();
		}
		return "";
	}
}
