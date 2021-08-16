package com.airport.locator.controller;

import com.airport.locator.model.Airport;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.ArrayList;

@Controller
public class LocatorController {

    @GetMapping("/")
    public String Locations(Model model) {
        // build empty list of airports
        var airports = new ArrayList<Airport>();

        // add data for each airport
        airports.add(new Airport(1, "Hartsfield - Jackson Atlanta International Airport", "KATL", "Atlanta, GA", "1026"));
        airports.add(new Airport(2, "Chicago O'Hare International Airport", "KORD", "Chicago, IL", "680"));
        airports.add(new Airport(3, "Los Angeles International Airport", "KLAX", "Los Angeles, CA", "127"));

        //add airports to view model
        model.addAttribute("airports", airports);

        // update view
        return "locations";
    }
}
