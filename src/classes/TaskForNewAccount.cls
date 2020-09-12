global class TaskForNewAccount {
    @InvocableMethod(Label = 'Create new Task object'
            Description = 'Creates new Task object for new or updated Accounts'
            category = 'Account')
    public static void addTaskForUpdatedAccount(List<InvocableVariablesWrapper> insertedRecords) {
        for (InvocableVariablesWrapper insertedRecord : insertedRecords) {
            List<Task> tasks = [SELECT Id FROM Task WHERE Account.Id = :insertedRecord.account.Id];
            User randomUser = getRandomUser();
            if (insertedRecord.IsNew||tasks.size() < 3) {
                Task task = createTask(insertedRecord.account);
                task.OwnerId = randomUser.Id;
                insert(task);
            } else {
                for (Task accTask : tasks) {
                    accTask.OwnerId = randomUser.Id;
                }
            }
        }
    }

    private static User getRandomUser() {
        List <User> activeUsers = [SELECT Id FROM User WHERE IsActive = TRUE];
        User randomUser = activeUsers.get(
                Integer.valueOf((Math.random() * (activeUsers.size() - 1))));
        return randomUser;
    }

    private static Task createTask(Account acc) {
        Task newTask = new Task(WhatId = acc.Id, Subject = 'Negotiations with ' + acc.Name);
        return newTask;
    }

    global class InvocableVariablesWrapper {
        @InvocableVariable(Required=true)
        global Account account;

        @InvocableVariable(Required=true)
        global Boolean IsNew;
    }
}