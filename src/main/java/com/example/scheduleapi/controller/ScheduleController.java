package com.example.scheduleapi.controller;

import com.example.scheduleapi.model.Schedule;
import com.example.scheduleapi.service.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/schedule")
public class ScheduleController {

    private final ScheduleService scheduleService;

    @Autowired
    public ScheduleController(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
    }

    @GetMapping
    public List<Schedule> getSchedulesByDate(@RequestParam("date") String date) {
        return scheduleService.getSchedulesByDate(date);
    }

    @PutMapping("/{id}")
    public void updateSchedule(@PathVariable String id, @RequestBody Schedule schedule) {
        scheduleService.updateSchedule(id, schedule);
    }
}