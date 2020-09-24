/**
 * Created by lina_ on 19.09.2020.
 */

public with sharing class TriggerContext {

    private static Boolean beforeRepeatedRun = false;
    private static Boolean afterRepeatedRun = false;

    public static Boolean isBeforeRepeatedRun() {
        return beforeRepeatedRun;
    }
    public static Boolean isAfterRepeatedRun() {
        return afterRepeatedRun;
    }

    public static void setBeforeRepeatedRunTrue() {
        beforeRepeatedRun = true;
    }

    public static void setAfterRepeatedRunTrue() {
        afterRepeatedRun = true;
    }
}
