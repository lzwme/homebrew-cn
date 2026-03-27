class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.53.tar.gz"
  sha256 "991506b14600ae5b6188319509d36e7451d840f34c24cf507d1dc4392cb08487"
  license "Artistic-2.0"
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e81b3a49cc4c30b591df57a3b4ce82a067f07fb9d7518cce4994e21576d03dee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "322a60a79cfcb76b255ac4d160e2944c14a503227822dbacbbc4a4f2da557f89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "954bcbcf6e8b0f06139b2b41bfb0113ce8b02178f7c9565efd119a08fc29c5c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "144302d49f608bd1730980953a7a027e5abb3aec265c65a4bb44fc98412e1adf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3f0f65969ce1349cbda9b9bb6c7c0b6e30ae0054a3ff240f1623e1767269c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4f22b812fa0be28dad834990cd99593f39b648b5f8911e3c2882ea5fa7e7ae3"
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