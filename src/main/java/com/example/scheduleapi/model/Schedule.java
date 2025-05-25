package com.example.scheduleapi.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "schedules")
public class Schedule {

    @Id
    private String id;
    private String date;
    private String name;
    private String content;
    private String timeBegin;
    private String timeEnd;

    // Constructor mặc định (yêu cầu bởi JPA)
    public Schedule() {}

    // Constructor có tham số
    public Schedule(String id, String date, String name, String content, String timeBegin, String timeEnd) {
        this.id = id;
        this.date = date;
        this.name = name;
        this.content = content;
        this.timeBegin = timeBegin;
        this.timeEnd = timeEnd;
    }

    // Getters và Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getTimeBegin() {
        return timeBegin;
    }

    public void setTimeBegin(String timeBegin) {
        this.timeBegin = timeBegin;
    }

    public String getTimeEnd() {
        return timeEnd;
    }

    public void setTimeEnd(String timeEnd) {
        this.timeEnd = timeEnd;
    }
}