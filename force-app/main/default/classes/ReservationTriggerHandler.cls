public class ReservationTriggerHandler {
    
    public static void checkOverlappingReservations(
        List<Reservation__c> newList, 
        Map<Id, Reservation__c> oldMap
    ) {
        Set<Id> roomIds = new Set<Id>();
        
        for (Reservation__c res : newList) {
            if (res.Room__c != null && res.Reservation_Status__c != 'Cancelled') {
                roomIds.add(res.Room__c);
            }
        }
        
        if (roomIds.isEmpty()) return;
        
        List<Reservation__c> existingReservations = [
            SELECT Id, Room__c, Check_In_Date__c, Check_Out_Date__c 
            FROM Reservation__c 
            WHERE Room__c IN :roomIds 
            AND Reservation_Status__c != 'Cancelled'
        ];
        
        for (Reservation__c newRes : newList) {
            if (newRes.Room__c == null || newRes.Reservation_Status__c == 'Cancelled') {
                continue;
            }
            
            for (Reservation__c oldRes : existingReservations) {
                if (newRes.Id == oldRes.Id) continue;
                if (newRes.Room__c != oldRes.Room__c) continue;
                
                if (newRes.Check_In_Date__c < oldRes.Check_Out_Date__c && 
                    newRes.Check_Out_Date__c > oldRes.Check_In_Date__c) {
                    
                    newRes.addError('This room is already booked for the selected dates.');
                }
            }
        }
    }
}