## Architecture and Design

Our F1 App is a complex software system that needs specific design choices to ensure that it functions properly and efficiently. Therefore, we employed several design patterns. We started using the Model-View-Controller (MVC), which separates our program into three components: the user, the app UI, and the user inputs – creating a link betweens these components helps the functionality of our app. Next, we used the Piper and Filters patterns to process data by breaking it down into manageable components (used for data about the results of the previous F1 seasons), this way we're able to process them more easily. Then, the Layered Architecture used to organize our system into a set of layers, that interact (strict or relaxed) with each other (i.e. interaction between menus, sections, subsections, etc). Finally, we employed the Repository architecture; this is used to manage data storage and retrieval (API). These design patterns help ensure that the F1 app is enabled to provide a greater experience to our users.

### Logical architecture

- `Email acount`: Tasks responsible for the user authentication in the app. The information about users stored here.
- `Formula1 database`: Communication between the database and logical part of the app, so as the information from the cloud can be retrieved and also uploaded.  
- `F1 app GUI`: Module responsible for drawing the app and allows the iteration of user/program.  
- `Business logic`: Module that establish the communications between the app storage services. The goal of this service is to retrieve information from the database.

![LogicalView](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC09T4/blob/main/images/logical_architecture.png)

### Physical architecture

In our app architecture we have 3 entities: the email server responsible to save all login information of the users, the F1 main server which will store all the information that the App will display and the app itself.

![DeploymentView](https://github.com/FEUP-LEIC-ES-2022-23/2LEIC09T4/blob/main/images/physical_architecture.png)

We used Flutter (Dart programming language) for the frontend and Firebase for the database and backend of our app.

### Vertical prototype

In this prototype, if you see the login page for the app:

<p>
 <img src= "https://github.com/FEUP-LEIC-ES-2022-23/2LEIC09T4/assets/114069759/7e24f844-a745-4066-b4ee-12439ffe414e"
height="400"/>
</p>






