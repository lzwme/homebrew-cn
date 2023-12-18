class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https:github.comtoddrXML-Parser"
  url "https:cpan.metacpan.orgauthorsidTTOTODDRXML-Parser-2.46.tar.gz"
  sha256 "d331332491c51cccfb4cb94ffc44f9cd73378e618498d4a37df9e043661c515d"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https:github.comtoddrXML-Parser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "473fbd1263ba43ca877ca887b777e5a9afce13768b6cfc2ff6285c4bc9971824"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4eac26785194dbcbd96bf24a8479db7ea85352a2a16b7972c922afd4d9ea68e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcde94080253f566a98b5f349b7ea010cc6d21fe6ddec59fa4743abc5edea58f"
    sha256 cellar: :any_skip_relocation, sonoma:         "de0c1626a94b200ebe015c45d8b1409efdd6e8d395aec19cf2d81d6af1aa2b0d"
    sha256 cellar: :any_skip_relocation, ventura:        "c6b74c83a127b6cadddb8509919dfee6627a598100f94f3d861fdb2a5163de4b"
    sha256 cellar: :any_skip_relocation, monterey:       "5572c581adfbe973e52db8be2aa407bffc0967ce6f9b2e3baa944634f7ec8cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3ac116881f491dd486c9951ad305fb55a73bfd6af80cb89fccc248e4f732ea8"
  end

  uses_from_macos "perl"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make", "PERL5LIB=#{ENV["PERL5LIB"]}"
    system "make", "install"
  end

  test do
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5" if OS.linux?
    system "perl", "-e", "require XML::Parser;"
  end
end