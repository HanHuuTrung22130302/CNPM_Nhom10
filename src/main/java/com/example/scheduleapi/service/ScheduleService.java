package com.example.scheduleapi.service;

import com.example.scheduleapi.model.Schedule;
import com.example.scheduleapi.repository.ScheduleRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class ScheduleService implements CommandLineRunner {

    private final ScheduleRepository scheduleRepository;

    public ScheduleService(ScheduleRepository scheduleRepository) {
        this.scheduleRepository = scheduleRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        // Thêm dữ liệu ảo vào MySQL khi ứng dụng khởi động
        List<Schedule> dummySchedules = Arrays.asList(
                new Schedule("1", "20-05-2025", "Lập trình di động", "Học Flutter và Dart", "08:00", "10:00"),
                new Schedule("2", "20-05-2025", "Cơ sở dữ liệu", "Ôn tập SQL", "13:00", "15:00"),
                new Schedule("3", "21-05-2025", "Mạng máy tính", "Học giao thức TCP/IP", "09:00", "11:00"),
                new Schedule("4", "22-05-2025", "Thiết kế giao diện", "Làm bài tập Figma", "14:00", "16:00")
        );

        scheduleRepository.saveAll(dummySchedules);
    }

    public List<Schedule> getSchedulesByDate(String date) {
        return scheduleRepository.findByDate(date);
    }

    public void updateSchedule(String id, Schedule schedule) {
        schedule.setId(id);
        scheduleRepository.save(schedule);
    }
}