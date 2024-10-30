class Cpanminus < Formula
  desc "Get, unpack, build, and install modules from CPAN"
  homepage "https:github.commiyagawacpanminus"
  # Don't use git tags, their naming is misleading
  url "https:cpan.metacpan.orgauthorsidMMIMIYAGAWAApp-cpanminus-1.7048.tar.gz"
  sha256 "59b60907ab9fa4f72ca2004fbe6054911439ae9a906890b4d842a87b25f20f3c"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  version_scheme 1

  head "https:github.commiyagawacpanminus.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e7998b2229d3419be9c48b534addac8852e302f9ab56bdfe13203fc5dcd8c274"
  end

  depends_on "perl" => :build

  def install
    cd "App-cpanminus" if build.head?

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}",
                                  "INSTALLSITEMAN1DIR=#{man1}",
                                  "INSTALLSITEMAN3DIR=#{man3}"
    system "make", "install"

    inreplace_files = [
      buildpath"README",
      bin"cpanm",
      lib"perl5Appcpanminusfatscript.pm",
      lib"perl5Appcpanminus.pm",
      man3"App::cpanminus.3",
    ]
    inreplace inreplace_files, "usrlocal", HOMEBREW_PREFIX, audit_result: build.stable?

    # Needed for dependents that might use Homebrew perl or system perl.
    inreplace bin"cpanm", %r{^#!#{Regexp.escape(Formula["perl"].opt_bin)}perl$}, "#!usrbinenv perl"
  end

  test do
    assert_match "cpan.metacpan.org", stable.url, "Don't use git tags, their naming is misleading"
    system bin"cpanm", "--local-lib=#{testpath}perl5", "Test::More"
  end
end