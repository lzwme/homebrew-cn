class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20250616/Perl-Tidy-20250616.tar.gz"
  sha256 "b07517e3f6198d24a4890665338847d79008f7dcc68461811905c7e62a1e689a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1fd4426e0132e1a9db7d54fbcbc22d98f2b5b3457b5cdb13a0f9c3710550668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1fd4426e0132e1a9db7d54fbcbc22d98f2b5b3457b5cdb13a0f9c3710550668"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f5079767e8809dbc6a32d4aff6939a1ac9e868ee654ab64d90cb8dd58e3d0c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c934e85ce310af8d03b97706f720b49bac1a87eb6ec6a0699e433f3490dd1a7"
    sha256 cellar: :any_skip_relocation, ventura:       "617b5a11c609463c3e0df734ce54e4f7488aec19a328e754d653956fb007eec7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "169931f10fe4c4bc33f9f410d8dad81c9e2351061f3deabbf1c1af87e76169a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f618cb5ec07ac3317ce6727c89ed854c57c29fafe61cce75476765495dea692"
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