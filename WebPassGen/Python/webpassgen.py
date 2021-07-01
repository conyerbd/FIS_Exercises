import requests
import html2text
import re
import random
import sys

passwordLength = 0
password = ''
dictionary = {}

inputLength = sys.argv[1]
try:
	passwordLength = int(inputLength)
except:
	print("Input must be a whole number greater than or equal to 8...")
	exit()

if passwordLength < 8:
	print("Input must be a whole number greater than or equal to 8...")
	exit()

URL = "https://en.wikipedia.org/wiki/Rome"

# get the html of the site
request = requests.get(URL)

# convert the html to text
text = html2text.html2text(request.text)

# filter unwanted symbols/words
cleanText = re.sub('[^a-zA-Z0-9\n]|https', ' ', text)

# capture words from filtered text
splitText = cleanText.split()

# add each word to the dictionary of words
for word in splitText:
	key = len(word)
	if key > 3:

		# don't add duplicate keys
		if key not in dictionary:
			dictionary[key] = list()

		# don't add duplicate words
		if word not in dictionary[key]:
			dictionary[key].append(word)

while passwordLength != 0:
	
	# we use 4 or 8 to handle situation where we must use a 4 character word.
	if passwordLength == 4 or passwordLength == 8:
		index = random.randrange(0, len(dictionary[4]))
		newWord = dictionary[4][index]
		password += newWord
		passwordLength -= 4

	elif passwordLength > 8:
		wordLength = random.randrange(4, passwordLength - 4)
		indexFound = False

		# we need to search for a word to add to our password
		while indexFound == False:
			indexFound = True

			# try to locate a word
			try:

				# for very large numbers we don't want to search for words longer
				# than our max length word
				if wordLength > sorted(dictionary.keys())[-1]:

					# we're ignoring the specified length and just using our max
					wordLength = random.randrange(4, sorted(dictionary.keys())[-1])

				# pick a random number between 0 and the length of the specified word	
				index = random.randrange(0, len(dictionary[wordLength]))

			# in the event there is no key for the length chosen we need to try again
			except:
				wordLength = random.randrange(4, passwordLength - 4)
				indexFound = False

		# grab our new word from the dictionary
		newWord = dictionary[wordLength][index]
		password += newWord
		passwordLength -= wordLength

	# for numbers between 4 and 8
	else:
		index = random.randrange(0, len(dictionary[passwordLength]))
		newWord = dictionary[passwordLength][index]
		password += newWord
		passwordLength -= passwordLength

print(password)