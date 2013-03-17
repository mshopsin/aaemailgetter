I made this little program so I don't have to constantly look up people's emails for App Academy code reviews each day.

It prints out something like:

    Hello dknauss!
    Your partner is: (partner name)
    Your desk number is: 13
    Your lecture time is: late
    Your reviewers are: (reviewer1) and (reviewer2)
    At 6PM, send your code to: email1@example.com, email2@example.com, email3@example.com, email4@example.com

It works from the command line like so:

`ruby aaemailgetter.rb (your condensed name) (your github username) (your github password)`

For instance, I would write:

`ruby aaemailgetter.rb dknauss daleknauss secret-password`

Of course, if you grab the code, you can always change the ARGV[0], ARGV[1], and ARGV[2] things to your condensed name, your github username, and your github password respectively.

Enjoy!
