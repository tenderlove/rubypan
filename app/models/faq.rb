class Faq
  Q_AND_A = [
   {:q => "What is RPAN Search?", 
    :a => "RPAN Search is a search engine for Ruby gems and gem releases.  It was conceived and built by Aaron Patterson 
           as a way to make Ruby gem releases easier to locate. ('RPAN' pays homage to CPAN and playfully 
           stands for 'Ruby Perl Archive Network' or 'Ruby Programmers Are Nice')."},
   {:q => "Why is gem X not listed in the catalog?", 
    :a => "You can file an issue on Github under 
          <a href='http://github.com/tenderlove/rubypan/issues'>tenderlove/rubypan</a>, where the source code resides."},
   {:q => "Can I get the results in XML format?  In Atom format?", 
    :a => "Currently Rubypan.org supports HTML, XML, and Atom format."},
   {:q => "Do you keep statistics on which gems are the most popular?", 
    :a => "Each release can be rated by you, the user, on a scale of 1 to 5 [gems].  
           The average and number of votes is recorded for each release."},
   {:q => "How can I release a gem?", 
    :a => "Visit <a href='http://rubygems.org/'>rubygems.org</a> for information on creating and releasing Ruby gems."},
   {:q => "How can I contribute to this website?", 
    :a => "The code is hosted on Github <a href='http://github.com/tenderlove/rubypan/tree/master'>
          http://github.com/tenderlove/rubypan/tree/master</a>. Feel free to fork the code, fix a bug, 
          create a feature, and send a pull request."}
  ]
  
  def all
    Q_AND_A
  end
end