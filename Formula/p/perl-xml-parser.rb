class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.52.tar.gz"
  sha256 "b06c78fe79afb959d020e4c66b930efcf4327b78df95e1afa13662ee8ba3d5cd"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a789392af5a37f2d34bb440056e817102ca18594e00895d0576c7e6e495d150b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9444219d7acde760d6285c53d6183d21bab5e9dd396d3bbabbe5221b7f55c9e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fc2afce72658507c6f42501405bff82a5f6cfffad7bbb0b6a9aea4c437e87c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4aedc75b7c3211e991acf67b5bd8c70d8c3eddc8639611455d347deeb552de58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7418585dff12e44045ebb850cf5da54e1919a4e871a9095a02a83ed842b741b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730f6a98a01890b6d339d58d5c6d3906fa9fdc4b1ffc315ae5065e9995c7b2ea"
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