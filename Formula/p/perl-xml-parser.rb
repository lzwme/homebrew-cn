class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.55.tar.gz"
  sha256 "7d2dd51a0c3f3441339dba2af3987052795adb532a8e05d967198c62dfb7db2f"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8aa24ffa82436a39b8da35b161e0743a321227b50c7ea8003bc384c92e4b994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99b51b949f590e5b5df596e95e2f36f5895aa3fdfeb28d947238c2e3ac8a2f29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ae60f9340f59ca29ebdad5c6661339d4d90096d44e71716e663cea7f3f59c8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "61286ba9ef8b5f5796f0ff66240a908195d541618fb44d56c9082b540fff33d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49c71ae2ef58dcd6fbdf573d3bf23034c47d946da782be36b4245464e2776c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39c076a3b2cf19e9104c86525c0b74822f16b2431fe4884b97d0ebb093b4a9f2"
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