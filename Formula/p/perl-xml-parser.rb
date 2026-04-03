class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.56.tar.gz"
  sha256 "a78bfcd3834fde7411acee2f5fcd74deeecfbaa8cee86f16c33c42dde2fd8fff"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a102ab8e7fc6f8c729075b45f37927d26db352959a992d5a06bd75cb4a187fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f39aa47aee3b3351694d96c152628ad0c389dd24a9593655c9c289d664edb0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85763a17083836d3a3090cf62dacd4d33a169b49056f9c167672e74c2ea2cf44"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5c26cdc636219021eb336f53344623d2e8fa87e37a641f061b54619bd185641"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa5799b7a71d8f333575c5378cca557fa048b4a1f195c33322fba8b1ab2c985d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f133d5131834016cbaee553f70496b5603568036baa9675c488c509ac5eab3ae"
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