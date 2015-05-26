#!/usr/bin/python3

import os
import time
import flickrapi
import json
import re
import getpass

flickr_api_key = "your_flickr_api_key"
flickr_api_secret = "your_flickr_api_secret"
flickr = flickrapi.FlickrAPI(flickr_api_key, flickr_api_secret, format='parsed-json')

template = '<a href="{pageURL}" title="{title} by YOURNAME, on Flickr"><img src="{photoSource}" width="{width}" height="{height}" alt="{title}"></a>'
blog_text_file = "/Users/" + getpass.getuser() + "/Desktop/blog.txt"

photoCounter = 1
list = []
filtered_list = []
blog_photos = []

pageURL = ""
title = ""
photoSource = ""
width = "0"
height = "0"

getPhotoID = re.compile("\/YOURNAME\/(\d+)/")

with open('/Users/' + getpass.getuser() + "/Desktop/flickrtabs.txt") as in_file:
    list = in_file.read().split('\n')

for url in filter(re.compile("https://www.flickr.com/photos/YOURNAME/\d+").match, list):
	filtered_list.append(url)

if not filtered_list:
	print("no pictures to process")
	exit

for url in filtered_list:
	print("Photo " + str(photoCounter) + " of " + str(len(filtered_list)))
	photoCounter += 1
	
	photoIDFromURL = getPhotoID.search(url).group(1)

	photoInfo = flickr.photos.getInfo(photo_id=str(photoIDFromURL))
	photoSizes = flickr.photos.getSizes(photo_id=photoIDFromURL)

	title = photoInfo["photo"]["title"]["_content"]
	pageURL = photoInfo["photo"]["urls"]["url"][0]["_content"]

	for size in photoSizes["sizes"]["size"]:
		if size["label"] == 'Medium 800':
			height = size["height"]
			width = size["width"]
			photoSource = size["source"]

			formattedURL = template.format(pageURL=pageURL, title=title, photoSource=photoSource, width=width, height=height)
			blog_photos.append(formattedURL)

if blog_photos:
	with open(blog_text_file,'w',encoding='utf8') as myFile:
		for item in blog_photos:
			myFile.write("%s\n\n" % item)