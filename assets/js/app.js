import css from "../css/app.css"
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"


var path = window.location.pathname;
var page = path.split("/").pop();

if(page == "signup") {
	let channel = socket.channel('signup:lobby', {})
	channel.on('shout', function (payload) {
	});

	channel.join();

	let username = document.getElementById('username');
	let password = document.getElementById('password');
	let confirmpassword = document.getElementById('confirm-password');
	let button = document.getElementById('signup');

	button.onclick = function() {
		console.log(password == confirmpassword);
		if(password.value != confirmpassword.value) {
			alert("Password and Confirm Password must be same!")
		} else {
			channel.push('shout', {
				username: username.value,
				password: password.value
			})
			.receive('ok', resp => {alert("Account created Successfully"); window.location.href = "http://localhost:4000"})
			.receive('userexists', resp => {alert("Username already exists")})
			;
		}
		password.value = '';
		confirmpassword.value = '';
	};
} else if(page == "") {
	let channel = socket.channel('room:lobby', {});
	channel.on('shout', function (payload) {
	});

	channel.join();

	let username = document.getElementById('username');
	let password = document.getElementById('password');
	let button = document.getElementById('login');

	button.onclick = function() {
		channel.push('shout', {
			username: username.value,
			password: password.value
		})
		.receive('ok', resp => {console.log("Successfully logged in"); window.location.href = "http://localhost:4000/twitter/" + username.value})
		.receive('noexist', resp => {alert("User doesn't exist")})
		.receive('incorrect', resp => {alert("Password or username incorrect")});
		password.value = '';
	};
}

let feedChannel = socket.channel('newsfeed:lobby', {});
let followChannel = socket.channel('follow:lobby', {});

feedChannel.on('shout', function (payload) { // listen to the 'shout' event
	let li = document.createElement("li");
	let tweet = payload.tweet;
	let tweeter = payload.tweeter;
	let name = payload.username;
	if(name == page) {
		li.innerHTML = '<p>' + name + ':<p> ' + payload.tweet;
		tweetsList.appendChild(li);
	}
});
feedChannel.on('shoutfeed', function (payload) { // listen to the 'shout' event
	let li = document.createElement("li");
	li.style.marginLeft = "5px";
	let tweet =  payload.tweet;
	let tweeter = payload.tweeter;
	let username = payload.username;
	let rt = document.createElement("button");
	//rt.style.marginLeft = "5px";
	//rt.style.color = "black";
	rt.onclick = function() {
		retweet(rt);
	};


	let innerDiv = document.createElement("div");
	innerDiv.style.border = "solid";
	innerDiv.style.borderWidth = "1px"
	innerDiv.style.marginBottom = "10px";
	innerDiv.style.padding = "5px";
	innerDiv.style.borderRadius = "5px";


	if(username == page) {
		li.innerHTML = '<p>' + tweeter + ':<p> ' + payload.tweet;
		feedList.appendChild(li);
		rt.style.background = "transparent";
		rt.style.backgroundImage = "url(/images/rt2.png)";
		rt.style.backgroundSize = "100%";
		rt.style.width = '40px';
		rt.style.height = '40px';
		rt.style.padding = '0px';
		rt.style.border = "none";
		//rt.style.object-fit = "cover";
		innerDiv.appendChild(li);
		innerDiv.appendChild(rt);
		feedList.appendChild(innerDiv);
	}
});

feedChannel.on('shoutgethashtags', function (payload) { // listen to the 'shout' event
	let li = document.createElement("li");
	console.log(payload);
	if(payload.hashtag == hashtagQueryHolder) {
		let tweet = payload.tweet;
		li.innerHTML = '<p>' + tweet + '<p>';
		hashtagResults.appendChild(li);
	}
	hashtagResults
});
feedChannel.on('shoutgetmentions', function (payload) { // listen to the 'shout' event
	let li = document.createElement("li");

	if(payload.mention == ("@" + page)) {
		let tweet = payload.tweet;
		li.innerHTML = '<p>' + tweet + '<p>';
		mentionsList.appendChild(li);
	}
});
feedChannel.join();

followChannel.on('shoutgetfollowers', function (payload) { // listen to the 'shout2' event
	let li = document.createElement("li");
	if(payload.username == page) {
		let name = payload.follower;
		li.innerHTML = '<p>' + name + '<p>';
		followersList.appendChild(li);
	}
});
followChannel.on('shoutgetfollowing', function (payload) { // listen to the 'shout2' event
	let li = document.createElement("li");
	if(payload.username == page) {
		let name = payload.following;
		li.innerHTML = '<p>' + name + '<p>';
		followingList.appendChild(li);
	}
});
followChannel.join();

let tweet = document.getElementById('tweet');
let tweetsList = document.getElementById('tweets-list');
let submitButton = document.getElementById('submit-tweet');

let userToFollow = document.getElementById('to-be-followed');
let followButton = document.getElementById('follow-user');

let getFollowersButton = document.getElementById('see-followers');
let getFollowingButton = document.getElementById('see-following');
let getMentionsButton = document.getElementById('see-mentions');

let followersList = document.getElementById('followers-list');
let followersDiv = document.getElementById('followers-div');

let followingList = document.getElementById('following-list');
let followingDiv = document.getElementById('following-div');

let mentionsList = document.getElementById('mentions-list');
let mentionsDiv = document.getElementById('mentions-div');

let feedList = document.getElementById('feed');
let feedDiv = document.getElementById('feed-div');

let hashtagQuery = document.getElementById('hashtag-query');
let hashtagQueryHolder = "";
let hashtagButton = document.getElementById('search-hashtags');
let hashtagResultsString = document.getElementById('hashtag-results-string');
let hashtagResults = document.getElementById('hashtags-results');

let logoutButton = document.getElementById('logout-button');
let deleteAccountButton = document.getElementById('delete-account-button');

let seeSelfTweetsButton = document.getElementById('see-selftweets');
let tweetsDiv = document.getElementById('tweets-div')


submitButton.onclick = function() {
	if(tweet.value == "") return;
	feedChannel.push('shout', {
		username: page,
		tweet: tweet.value
	})

	feedChannel.push('shoutfeed', {
		username: page,
		tweet: tweet.value,
		tweeter: page,
	})

	let hashtags = tweet.value.split(' ').filter(v=> v.startsWith('#'));
	for(let i=0; i < hashtags.length; i++)
	{
		let curr = hashtags[i];
		feedChannel.push('shouthashtag', {
			count: 1,
			hashtag: curr,
			tweet: tweet.value
		})
	}

	let mentions = tweet.value.split(' ').filter(v=> v.startsWith('@'));
	for(let i=0; i < mentions.length; i++)
	{
		let curr = mentions[i];
		feedChannel.push('shoutmention', {
			mention: curr,
			tweet: tweet.value
		})
	}

	tweet.value = '';
};

followButton.onclick = function() {
	if(userToFollow.value == "") return;
	alert("Followed " + userToFollow.value + " successfully")
	followChannel.push('shout', {
		follower: page,
		username: userToFollow.value
	})
	followChannel.push('shout2', {
		following: userToFollow.value,
		username: page
	})
	userToFollow.value = '';
};

hashtagButton.onclick = function() {
	if(hashtagQuery.value == "") return;
	hashtagResultsString.style.display = "block";
	hashtagQueryHolder = hashtagQuery.value;
	hashtagResults.innerHTML = "";
	feedChannel.push('shoutgethashtags', {
		count: 0,
		hashtag: "#test",
		tweet: "tweet"
	})
	hashtagQuery.value = '';
};

getFollowersButton.onclick = function() {
	followChannel.push('shoutgetfollowers', {
		// username: page
	})
	if (followersDiv.style.display === "none") {
		followersDiv.style.display = "block";
		mentionsDiv.style.display = "none";
		followingDiv.style.display = "none";
	} else {
		followersDiv.style.display = "none";
	}
};

getFollowingButton.onclick = function() {
	followChannel.push('shoutgetfollowing', {
		// username: page
	})
	if (followingDiv.style.display === "none") {
		followingDiv.style.display = "block";
		mentionsDiv.style.display = "none";
		followersDiv.style.display = "none";
	} else {
		followingDiv.style.display = "none";
	}
};

getMentionsButton.onclick = function() {
	feedChannel.push('shoutgetmentions', {
		// username: page
	})
	if (mentionsDiv.style.display === "none") {
		mentionsDiv.style.display = "block";
		followingDiv.style.display = "none";
		followersDiv.style.display = "none";
	} else {
		mentionsDiv.style.display = "none";
	}
};
seeSelfTweetsButton.onclick = function() {
	if (tweetsDiv.style.display === "none") {
		tweetsDiv.style.display = "block";
	} else {
		tweetsDiv.style.display = "none";
	}
};

logoutButton.onclick = function() {
	window.location.href = "http://localhost:4000";
};

deleteAccountButton.onclick = function() {
	let password = prompt("Password");
	let signupChannel = socket.channel('signup:lobby', {})
	signupChannel.join();
	signupChannel.push('shoutdeleteaccount', {
		username: page,
		password: password
	})
	.receive('ok', resp => {alert("Account successfully deleted :("); window.location.href = "http://localhost:4000"})
	.receive('noexist', resp => {alert("Can't delete account. User doesn't exist")})
	.receive('incorrect', resp => {alert("Password incorrect")});
};

function retweet(rt) {
	let children = rt.parentElement.childNodes;
	let unparsedtweet = children[0].innerText;
	let parsedarr = unparsedtweet.split(':');
	let finaltweet = " retweeted " + parsedarr[0] + "'s tweet: " + parsedarr[1];
	alert("Retweeted");

	feedChannel.push('shout', {
		username: page,
		tweet: finaltweet
	});

	feedChannel.push('shoutfeed', {
		username: page,
		tweet: finaltweet,
		tweeter: page
	});
}