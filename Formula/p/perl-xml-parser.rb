class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.54.tar.gz"
  sha256 "803bcd50eaf1fda0820056bb1ec485cdd1c04bca680394879b5e6a0be35597c6"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fed975436e3f75a1406be6d168b01269b239223f64288173e42a260ba35f7a59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57ae032f0a8269dc6969f027b447c8f77c2c4c8e5d1d501b8e8ba911be5b1f67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4082033a3e09a5c50b9d7aee71d20b7b13ca76e0f2afc1f250de9a45d9709b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ef18fe65521b3c7d0c7d521e7261d08d84ffdd0e4e2d3224e370a0a180700b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b74afab4e83849f433cbcc97ae67e13d47bfe5bdb23ce7cd8b21aa19bbfab0cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee22c529583f7d5b66cafd9ffb3f097cd206187337591bbfab79458be868745"
  end

  depends_on "perl" # macOS Perl already has the XML::Parser module
  uses_from_macos "expat"

  resource "File::ShareDir::Install" do
    url "https://cpan.metacpan.org/authors/id/E/ET/ETHER/File-ShareDir-Install-0.14.tar.gz"
    sha256 "8f9533b198f2d4a9a5288cbc7d224f7679ad05a7a8573745599789428bc5aea0"
  end

  def install
    resource("File::ShareDir::Install").stage buildpath/"File-ShareDir-Install"
    ENV.prepend_path "PERL5LIB", buildpath/"File-ShareDir-Install/lib"

    # Homebrew vendors the new configure-time helper but does not package
    # File::ShareDir at runtime, so keep XML::Parser's legacy @INC fallback.
    inreplace "Expat/Expat.pm",
              "use File::ShareDir ();",
              ""
    inreplace "Expat/Expat.pm",
              "eval { $_share_dir = File::ShareDir::dist_dir('XML-Parser') };",
              "eval {\n    require File::ShareDir;\n    $_share_dir = File::ShareDir::dist_dir('XML-Parser');\n};"

    system "perl", "Makefile.PL", "INSTALLDIRS=vendor", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system Formula["perl"].opt_bin/"perl", "-e", "require XML::Parser;"
  end
end