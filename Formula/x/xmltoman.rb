require "language/perl"

class Xmltoman < Formula
  include Language::Perl::Shebang

  desc "XML to manpage converter"
  homepage "https://sourceforge.net/projects/xmltoman/"
  url "https://downloads.sourceforge.net/project/xmltoman/xmltoman/xmltoman-0.4.tar.gz/xmltoman-0.4.tar.gz"
  sha256 "948794a316aaecd13add60e17e476beae86644d066cb60171fc6b779f2df14b0"
  license "GPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e552f3d2b725328b391473bf7e814376a87f6aee62802984470e86c7f230c7cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb945c423d08c88f0c8409149f4fd0314a46607be23429d756a9fd9bd2771a56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb945c423d08c88f0c8409149f4fd0314a46607be23429d756a9fd9bd2771a56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb945c423d08c88f0c8409149f4fd0314a46607be23429d756a9fd9bd2771a56"
    sha256 cellar: :any_skip_relocation, sonoma:         "411e25e66b751e4e3e069a449c519bbf28f717eb35fa472c45a07761b6bf4c85"
    sha256 cellar: :any_skip_relocation, ventura:        "5678e1d8274ec425e903d5263ba20d46b2cd931e33c161da471553f7e0f31d37"
    sha256 cellar: :any_skip_relocation, monterey:       "5678e1d8274ec425e903d5263ba20d46b2cd931e33c161da471553f7e0f31d37"
    sha256 cellar: :any_skip_relocation, big_sur:        "5678e1d8274ec425e903d5263ba20d46b2cd931e33c161da471553f7e0f31d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77405cd2dfce160d216caf3513365b00f3af4cd01565b3ebd12dc1d4233a6a86"
  end

  uses_from_macos "perl"

  resource "XML::Parser" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
          system "make", "install"
        end
      end

      inreplace "xmltoman", "#!/usr/bin/perl -w", "#!/usr/bin/env perl"
      rewrite_shebang detected_perl_shebang, "xmlmantohtml"
    end

    # generate the man files from their original XML sources
    system "./xmltoman xml/xmltoman.1.xml > xmltoman.1"
    system "./xmltoman xml/xmlmantohtml.1.xml > xmlmantohtml.1"

    man1.install %w[xmltoman.1 xmlmantohtml.1]
    bin.install %w[xmltoman xmlmantohtml]
    pkgshare.install %w[xmltoman.xsl xmltoman.dtd xmltoman.css]

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"]) if OS.linux?
  end

  test do
    assert_match "You need to specify a file to parse", shell_output("#{bin}/xmltoman 2>&1", 1).strip
  end
end