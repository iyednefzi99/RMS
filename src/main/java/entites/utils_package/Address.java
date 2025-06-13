package entites.utils_package;

/**
 * Address class represents a physical address with its components.
 */
public class Address {
    private String streetAddress; // Street address
    private String city; // City
    private String state; // State
    private String zipCode; // Zip code
    private String country; // Country

    // Constructor for creating an address with required fields
    public Address(String street, String city, String state, String zipCode) {
        this.streetAddress = street;
        this.city = city;
        this.state = state;
        this.zipCode = zipCode;
    }

    // Getters and setters
    public String getStreet() { return streetAddress; }
    public String getCity() { return city; }
    public String getState() { return state; }
    public String getZipCode() { return zipCode; }
    public String getCountry() { return country; }

    public void setStreet(String street) { this.streetAddress = street; }
    public void setCity(String city) { this.city = city; }
    public void setState(String state) { this.state = state; }
    public void setZipCode(String zipCode) { this.zipCode = zipCode; }
    public void setCountry(String country) { this.country = country; }

    public void displayAddress() {
        System.out.println("Address: " + streetAddress + ", " + city + ", " + state + " " + zipCode); // Displays the address
    }

}