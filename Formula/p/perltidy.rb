class Perltidy < Formula
  desc "Indents and reformats Perl scripts to make them easier to read"
  homepage "https://perltidy.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/perltidy/20230909/Perl-Tidy-20230909.tar.gz"
  sha256 "e0f00b82822842516dbfa0228d8102122e6fa68c358f71a4be5626ad2cd19b4c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/Perl-Tidy[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45dd3629cd551fe8e0f360d1b47d78c35239a53db1376a96d7c90e611f21fbeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45dd3629cd551fe8e0f360d1b47d78c35239a53db1376a96d7c90e611f21fbeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d47f7d3ee4883cbf6f4b30215fab0a76198cdcf482b7d8b7ac1bbfe9e1388033"
    sha256 cellar: :any_skip_relocation, ventura:        "4fb24ff796f057ebf86f6edc2a312121766d8c597b4ac9b05e84458324d4390f"
    sha256 cellar: :any_skip_relocation, monterey:       "4fb24ff796f057ebf86f6edc2a312121766d8c597b4ac9b05e84458324d4390f"
    sha256 cellar: :any_skip_relocation, big_sur:        "423c9509edbe6949a74d6a604fc17a7b1ee11246826ddd49d1b55a7bad3c8077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb52d5160c2616fef5baa8af80338ac3c4e0d85e460f37de5b74efb4da5e0eb6"
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
    (testpath/"testfile.pl").write <<~EOS
      print "Help Desk -- What Editor do you use?";
      chomp($editor = <STDIN>);
      if ($editor =~ /emacs/i) {
        print "Why aren't you using vi?\n";
      } elsif ($editor =~ /vi/i) {
        print "Why aren't you using emacs?\n";
      } else {
        print "I think that's the problem\n";
      }
    EOS
    system bin/"perltidy", testpath/"testfile.pl"
    assert_predicate testpath/"testfile.pl.tdy", :exist?
  end
end