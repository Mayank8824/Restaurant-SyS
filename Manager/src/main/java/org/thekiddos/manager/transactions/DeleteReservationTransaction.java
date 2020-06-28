package org.thekiddos.manager.transactions;

import lombok.Getter;
import org.thekiddos.manager.models.Reservation;
import org.thekiddos.manager.repositories.Database;

import java.time.LocalDate;
import java.util.List;

public class DeleteReservationTransaction implements Transaction {
    private static final Long NO_CUSTOMER = -1L;
    private final Long tableId;
    private final LocalDate reservationDate;
    @Getter
    private final Long customerId;
    private boolean reservationExists = false;

    public DeleteReservationTransaction( Long tableId, LocalDate reservationDate ) {
        this.tableId = tableId;
        this.reservationDate = reservationDate;
        this.customerId = getReserveId();
        if ( this.customerId != null )
            reservationExists = true;
    }

    private Long getReserveId() {
        List<Reservation> tableReservation = Database.getReservationsByTableId( tableId );
        for ( Reservation reservation : tableReservation )
            if ( reservation.getDate().equals( reservationDate ) )
                return reservation.getCustomerId();
        return NO_CUSTOMER;
    }

    @Override
    public void execute() {
        // TODO use index to delete after using the equals and hash methods
        if ( reservationExists )
            Database.deleteReservation( tableId, reservationDate );
    }
}