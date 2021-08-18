package com.airport.locator.model;

// airport model for use in view template
public class Airport {
    private int id;
    private String name;
    private String code;
    private String location;
    private String elevation;

    public Airport(int id, String name, String code, String location, String elevation) {
        this.id = id;
        this.name = name;
        this.code = code;
        this.location = location;
        this.elevation = elevation;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getElevation() {
        return elevation;
    }

    public void setElevation(String elevation) {
        this.elevation = elevation;
    }
}
