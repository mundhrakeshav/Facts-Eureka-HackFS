# TheFacts
TheFacts is a decentralized, censorship resistant and pay per post news, articles and fact sharing mobile application. The application uses Ethereum based smart contracts
and Inter Planetary File System (IPFS) to store the application content.

### To build it check out respective frontend and backend directory.

## Idea
The core idea was to have a censorship resistance and decentralized news sharing platform where in users can submit posts related to any topic and incase of wrong information
being provided, the users can add threads to that particular post in support or against it. The publishers of the post can earn Ethereum based crypto tokens when anybody chooses
to view their post. The threads in a post also can be upvoted by other users and depending on the number of upvotes, the publisher of the thread can also earn incentives.

## Business Model
Posting of an article/post will be completely free. The users will be displayed a thumbnail and title for every post on the home page and they can choose to pay for the post they
like and view the full content along with all the threads and also they can contribute to that particular post by submitting their own thread. For every purchase of a post, there
will be fees which the publisher has to pay (it is automatically deducted by the smart contract). That fees will be utilized to pay gas fees for the services and maintenance of the
application. The incentives for the threads will also be paid from part of the fees collected.

## Getting started
[Download](https://drive.google.com/file/d/1U9Xko5VcafD9ZhzRQNXzNb3wIBMkjuuO/view?usp=drivesdk) the application.

1. Signup with your email id and password.

<p align="center">
    <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/Login.png">
</p>

2. After signing up, you can login and you will be redirected to homepage, you will also receive an ethreum address and a signup reward bonus of 1000 tokens.
All the posts are listed on homepage. In latest first fashion. 
* Each Item in list has got summary about the content like title and number of threads, upvotes and total donations to this post.

<p align="center">
  <row>
    <col>
      <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/Homepage.png">
    </col>
    <col>
      <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/Drawer.png">
    </col>
  </row>
</p>

3. When you choose to view any post you will receive an message asking to purchase it.
4. Price of each post by default for now is set to 100 tokens. After purchase you be able to view that post along with all of its contents. It might take a few seconds for the transaction to confirm.

<p align="center">
   <row>
    <col>
      <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/payForPost.png">
    </col>
    <col>
      <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/Post.png">
    </col>
    <col>
      <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/Post2.png">
    </col>
    <col>
      <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/viewthread.jpeg">
    </col>
  </row>
</p>

5. You can also donate to any post/thread, upvote them and add threads to them.

<p align="center">
   <row>
    <col>
      <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/donate.png">
    </col>
    <col>
      <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/TxDOne.png">
    </col>
    <col>
      <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/TxOnEtherScan.png">
    </col>
  </row>
</p>

6. You can add your own post with desired content and images which will be safely stored on IPFS via Textile.io's ThreadsDB. Ownership of the post can be tracked using your ethereum address.
<p align="center">
    <img width="200" height="400" src="https://github.com/mundhrakeshav/Facts-Eureka-HackFS/blob/contractTest/ScreenShots/newpost.jpeg">
</p>

7. You can also purchase more tokens if needed. The purchase option is available in the drawer, for now its just a dummy puchase page where you can add desired amount and the tokens will be bought for you. In production application there will be integration of payment gateways through which the purchase will be made.

### Built with
1. [Flutter](https://www.flutter.dev)
2. [Textile.io](https://textile.io)
3. [BlockVigil's API Gateway](https://blockvigil.com)

## Authors
1. ***Keshav Mundhra*** - [mundhrakeshav](https://github.com/mundhrakeshav)
2. **Vaibhav Muchandi** - [vaibhavmuchandi](https://github.com/vaibhavmuchandi)
3. **Jagadish Babu V** - [vjagadishvaranasi](https://github.com/vjagadishvaranasi)
4. **Alok** - [pixelpunch](https://github.com/pixelpunch)

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
