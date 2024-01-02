## Ethernaut Solutions


This project aims to streamline the completion of Ethernaut levels by providing automated scripts for executing attacks effortlessly. Ethernaut, offers a series of challenges called levels that require participants to identify vulnerabilities and exploit them. This project simplifies the process by automating the execution of attacks, allowing users to focus on understanding the vulnerabilities rather than dealing with manual steps. 
Even though I strongly recommend going over all levels in detail to improve personal knowledge.


## Requirements 

## Documentation
The only requirement is Foundry, take a look at [the official documentation](https://book.getfoundry.sh/) in case don't know how it works.

## How to use

Once the repository is cloned, will have to configure the customized script parameters such as Ethereum wallet addresses, private keys, or any environment-specific details. 

Create a `.evn` file similar to `.env.example`. 

IMPORTANT: Make sure you have that new file in your `.gitignore`.


Run the provided scripts for the desired Ethernaut level. 

To check the level will work correctly run 

```shell
$ make test-attack lvl= <lvlNumber>
```

And to run the attack 


```shell
$ make run-attack lvl= <lvlNumber>
```

## Contributions

Contributions to the project are welcome. Users can submit additional automation scripts for new levels or improvements to existing ones. The project encourages collaboration and the sharing of knowledge within the Ethereum security community.

