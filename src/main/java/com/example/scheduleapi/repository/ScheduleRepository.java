package com.example.scheduleapi.repository;

import com.example.scheduleapi.model.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, String> {
    // 1.9. Gọi findByDate(date) tìm kiếm lịch trong repository (Normal Flow)
    // 1.12. Trả dữ liệu (Schedule*) từ repository (Normal Flow)
    List<Schedule> findByDate(String date);
}