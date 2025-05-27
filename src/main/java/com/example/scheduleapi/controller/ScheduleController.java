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
    // 1.7. Gọi getSchedulesByDate(date) truy vấn lịch theo ngày từ service (Normal Flow)
    @GetMapping
    public List<Schedule> getSchedulesByDate(@RequestParam("date") String date) {
        // 1.14. Trả dữ liệu JSON từ controller (Normal Flow)
        return scheduleService.getSchedulesByDate(date);
    }

    @PutMapping("/{id}")
    public void updateSchedule(@PathVariable String id, @RequestBody Schedule schedule) {
        scheduleService.updateSchedule(id, schedule);
    }
}