/**
 * Created by lina_ on 19.09.2020.
 */

public with sharing class TriggerContext {

    private static Boolean beforeInsertRepeatedRun = false;
    private static Boolean afterInsertRepeatedRun = false;
    private static Boolean beforeUpdateRepeatedRun = false;
    private static Boolean afterUpdateRepeatedRun = false;

    public static Boolean isBeforeInsertRepeatedRun() {
        return beforeInsertRepeatedRun;
    }
    public static Boolean isAfterInsertRepeatedRun() {
        return afterInsertRepeatedRun;
    }

    public static void setBeforeInsertRepeatedRunTrue() {
        beforeInsertRepeatedRun = true;
    }

    public static void setAfterInsertRepeatedRunTrue() {
        afterInsertRepeatedRun = true;
    }

    public static Boolean isBeforeUpdateRepeatedRun() {
        return beforeUpdateRepeatedRun;
    }
    public static Boolean isAfterUpdateRepeatedRun() {
        return afterUpdateRepeatedRun;
    }

    public static void setBeforeUpdateRepeatedRunTrue() {
        beforeUpdateRepeatedRun = true;
    }

    public static void setAfterUpdateRepeatedRunTrue() {
        afterUpdateRepeatedRun = true;
    }
}
