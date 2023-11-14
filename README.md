# Telegram_bot 
## Development of a functional Telegram bot with root command and customizations
### Link: https://t.me/zadorozhnai_bot

### Instructions
1. Starting GitHub Codespaces.
2. Module initialization. This will create the go.mod file where we will store all the modules that are used in the code.
   **`go mod init github.com/ZadorozhnaI/kbot`**
3. Installing the Cobra CLI code generator. Cobra is a library providing a simple interface to create powerful modern CLI interfaces similar to git & go tools. Go will automatically install it in your $GOPATH/bin directory which should be in your $PATH.  
  **`go install github.com/spf13/cobra-cli@latest`**
4. From within a Go module run **`cobra-cli init`**. This will create a new barebones project for you to edit. It is a very powerful application that will populate your program with the right structure so you can immediately enjoy all the benefits of Cobra. It can also apply the license you specify to your application.
5. The **main.go** file imports our root package with the generated code.  
The **root.go** file is the basic command code with execution description blocks and configuration parameters. The command will be called by default when the program is executed without parameters.  
We will generate the code for the Version command.  
**`cobra-cli add version`**  
We have a new file **version.go** in the cmd directory.
6. Let's run the code build.  
**`go run main.go help`**
7. Let's check the version command we added to the code. The program returned the text string **`version called`**.  
   **`go run main.go version`**
8. Let's add a command that will contain the main program code.  
**`cobra-cli add kbot`**
9. Add the appVersion variable to output the program version. The variable is added to the **version.go** file.  
    `var appVersion = "Version"`  
   ```go
   Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(appVersion)
	},
   ```
11. When deploying applications into a production environment, building binaries with version information and other metadata will improve your monitoring, logging, and debugging processes by adding identifying information to help track your builds over time. This version information can often include highly dynamic data, such as build time, the machine or user building the binary, the Version Control System (VCS) commit ID it was built against, and more. Because these values are constantly changing, coding this data directly into the source code and modifying it before every new build is tedious and prone to error: Source files can move around and variables/constants may switch files throughout development, breaking the build process.  
One way to solve this in Go is to use **`-ldflags`** with the **`go build`** command to insert dynamic information into the binary at  build time, without the need for source code modification. In this flag, **`ld`** stands for linker, the program that links      together the different pieces of the compiled source code into the final binary. **`ldflags`**, then, stands for linker flags.  It is called this because it passes a flag to the underlying Go toolchain linker, **`cmd/link`**, that allows you to change the  values of imported packages at build time from the command line.  
The **`"-X"`** parameter assigns the value of variables in modules.  
**`go build -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=v1.0.0`**
12. We got the binary file kbot. Let's run it with the version parameter **`./kbot version`**. As a result, we got the program version **`v.1.0.0`**
13. We import the package using an import declaration, which consists of an identifier to be used in the code and an import pass, i.e. the place where to get the package code.
Add a module to the kbot.go file.  
```go
import (
	"fmt"

	"github.com/spf13/cobra"
)
```
Golang telebot is a framework for writing custom bots for the Telegram Bot API.  
gopkg.in provides versioned URLs that contain appropriate metadata to redirect the Go tool to clearly labeled GitHub repositories.
14. Declare the TeleToken variable. The value will be obtained automatically during program start using os.Getenv.
Declare the **`os`** module in the **`import`** block. 
```go
var (
	// TeleToken bot
	TeleToken = os.Getenv("TELE_TOKEN")
)
```
15. Let's add the code of the **`run`** function in the Handler block. This will be the line to output the version using the Printf of the fmt package. It implements formatted output with functions, uses so-called adverbs of different data types, in this case string bytes of appVersion variable values.
```go
Run: func(cmd *cobra.Command, args []string) {

		fmt.Printf("kbot %s started", appVersion)
```
16. The next step is the kbot initialization block, which is the creation of a new bot with parameters.
```go
Run: func(cmd *cobra.Command, args []string) {

		fmt.Printf("kbot %s started", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})
```
Declare the **`time`** module in the **`import`** block.
17. The next block is an error handler and if kbot returns something other than null we will call log.Fatalf with an error message, most likely it will be related to the token, so let's denote it that way.
```go
Run: func(cmd *cobra.Command, args []string) {

		fmt.Printf("kbot %s started", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})
		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		}
```
18. The Handler code will handle the **`telebot.OnText`** event, i.e. when we will receive new messages. This will be done by a function with parameters that contains **`telebot.Context`**, i.e. metadata and payload of the text message. Let's add **`kbot.start`** to start the Handler and its code. Return the value of payload, message text and the function termination code.
```go
Run: func(cmd *cobra.Command, args []string) {

		fmt.Printf("kbot %s started", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})
		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		}

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {

			log.Print(m.Message().Payload, m.Text())
			payload := m.Message().Payload

			switch payload {
			case "hello":
				err = m.Send(fmt.Sprintf("Hello I`m Kbot %s!", appVersion))

			}

			return err
		})
		kbot.Start()

	},
```
19. We're ready for the test. Run **`gofmt -s -w ./`** to format the code.
20. Run go get to download and install packages and dependencies.  
**`go get`**
21. Run the program build under the version **`1.0.1`**. 1 in the end indicates a minor change, i.e. a version patch.    
**`go build -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=v1.0.1`**
22. Add an alias for our command.  Run the build again.
```go
var kbotCmd = &cobra.Command{
	Use:     "kbot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:
```
23. Prepare the bot. Search BotFather in Telegram - he manages all bots officially. We use it to create a new account.  
**`/newbot`**  Choosing a name. Copy the token that was generated during creation.
24. You can assign an environment variable safely so that no sensitive information is left.
**`read -s TELE_TOKEN`** Press **`Enter`** and **`next Ctrl+V`**.
Checking **`echo $TELE_TOKEN`**
Export variable **`export TELE_TOKEN`**
25. Add a transition operator and create a handler for sending a response to the "hello" payload.
```go
Run: func(cmd *cobra.Command, args []string) {

		fmt.Printf("kbot %s started", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})
		if err != nil {
			log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
			return
		}

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {

			log.Print(m.Message().Payload, m.Text())
			payload := m.Message().Payload

			switch payload {
			case "hello":
				err = m.Send(fmt.Sprintf("Hello I`m Kbot %s!", appVersion))

			}

			return err
		})
		kbot.Start()

	},
}
```
Build patch version 1.0.2  
**`go build -ldflags "-X="github.com/ZadorozhnaI/kbot/cmd.appVersion=v1.0.2`**   
27. Launch the program **`./kbot start`**  
When you call the command in Telegram **`/start hello`**, the bot sends the program version.
