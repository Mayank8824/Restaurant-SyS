package org.thekiddos.manager.models;

import lombok.Data;
import lombok.Getter;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@RequiredArgsConstructor
public class TimeCard {
    @NonNull
    private LocalDate date;
    @NonNull
    private LocalTime timeWorked;
}