class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20250214/Perl-Tidy-20250214.tar.gz"
  sha256 "e71d8e93b2ff55ed7e0cc981117424499edfc927e96e353dbc6fbea1f2a81fa3"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ee5efe95b880ec874da6787b052f8219a30d0bb4b250a083cd403587fc26891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ee5efe95b880ec874da6787b052f8219a30d0bb4b250a083cd403587fc26891"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "556f21473dd01b09e5b9a797f9251b548e4b4b9ab5bc920fd7d77fd3cb902a1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "55335a839952b8e945f035ec77a37f5f2adfd5908c4016e9e3c9fd51dd20e71f"
    sha256 cellar: :any_skip_relocation, ventura:       "a0adb668002c281c54f3d8d858af8698a98f0a69b4f66a7d706984c5cc40fc50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "061d7dc624d1c263e384e2540eeb8c522ff2f4b818d9e364bc644cc5298179a4"
  end

  uses_from_macos "perl"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}",
                                  "INSTALLSITESCRIPT=#{bin}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    (testpath/"testfile.pl").write <<~PERL
      print "Help Desk -- What Editor do you use?";
      chomp($editor = <STDIN>);
      if ($editor =~ /emacs/i) {
        print "Why aren't you using vi?";
      } elsif ($editor =~ /vi/i) {
        print "Why aren't you using emacs?";
      } else {
        print "I think that's the problem";
      }
    PERL
    system bin/"perltidy", testpath/"testfile.pl"
    assert_equal <<~PERL, (testpath/"testfile.pl.tdy").read
      print "Help Desk -- What Editor do you use?";
      chomp( $editor = <STDIN> );
      if ( $editor =~ /emacs/i ) {
          print "Why aren't you using vi?";
      }
      elsif ( $editor =~ /vi/i ) {
          print "Why aren't you using emacs?";
      }
      else {
          print "I think that's the problem";
      }
    PERL
  end
end