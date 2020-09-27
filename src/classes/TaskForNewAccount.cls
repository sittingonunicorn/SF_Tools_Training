global class TaskForNewAccount {
    @InvocableMethod(Label = 'Create new Task object'
            Description = 'Creates new Task object for new or updated Accounts')
    public static void addTaskForUpsertedAccount(List<InvocableVariablesWrapper> upsertedRecords) {
        List<Id>accIds = new List<Id>();
        for (InvocableVariablesWrapper insertedRecord : upsertedRecords) {
            accIds.add(insertedRecord.account.Id);
        }
        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE Account.Id IN :accIds];
        List <User> activeUsers = [SELECT Id FROM User WHERE IsActive = TRUE];
        for (InvocableVariablesWrapper upsertedRecord : upsertedRecords) {
            List<Task> accountTasks = getAccountTasks(tasks, upsertedRecord.account.Id);
            User randomUser = getRandomUser(activeUsers);
            if (upsertedRecord.IsNew || accountTasks.size() < 3) {
                Task task = createTask(upsertedRecord.account);
                task.OwnerId = randomUser.Id;
                tasks.add(task);
            } else {
                for (Task accTask : accountTasks) {
                    accTask.OwnerId = randomUser.Id;
                }
            }
        }
        upsert tasks;
    }

    private static List<Task> getAccountTasks(List<Task> tasks, Id id) {
        List<Task> insertTasks = new List<Task>();
        for (Task task : tasks) {
            if (task.WhatId == id) {
                insertTasks.add(task);
            }
        }
        return insertTasks;
    }

    public static User getRandomUser(List <User> activeUsers) {
        User randomUser = activeUsers.get(
                Integer.valueOf((Math.random() * (activeUsers.size()-1))));
        return randomUser;
    }

    private static Task createTask(Account acc) {
        Task newTask = new Task(WhatId = acc.Id, Subject = 'Negotiations with '+acc.Name);
        return newTask;
    }

    global class InvocableVariablesWrapper {
        @InvocableVariable(Required=true)
        global Account account;

        @InvocableVariable(Required=true)
        global Boolean IsNew;
    }
}