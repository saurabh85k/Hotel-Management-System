trigger ReservationTrigger on Reservation__c (
    before insert, before update
) {
    ReservationTriggerHandler.checkOverlappingReservations(
        Trigger.new, 
        Trigger.oldMap
    );
}