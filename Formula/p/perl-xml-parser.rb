class PerlXmlParser < Formula
  desc "Perl module for parsing XML documents"
  homepage "https://github.com/cpan-authors/XML-Parser"
  url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.47.tar.gz"
  sha256 "ad4aae643ec784f489b956abe952432871a622d4e2b5c619e8855accbfc4d1d8"
  license "Artistic-2.0"
  revision 2
  head "https://github.com/cpan-authors/XML-Parser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cabcebf3802feb57d19d68387eba1c7cefc4bf40613a5659a8d3a3887133d9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0172a701a5d434f28a3e4f6e74db3242482c45622df5266718cbb0d0e6296149"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9593d0a1cac40934bbfc34a96281ea98bcfd0bcb4d79848122cd636000bb9798"
    sha256 cellar: :any_skip_relocation, sonoma:        "2597486c200df8fd609293050e872dc909768c8fe89236ba31b93c1e022dbc38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "788210abae2782fccb7e830a896992c0cccc03724df4038905d8b679a26fc7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb440145a157f5c4b1426c420808ff3c70062624ed2a1e637d45b7f58cf3772c"
  end

  depends_on "perl" # macOS Perl already has the XML::Parser module
  uses_from_macos "expat"

  def install
    system "perl", "Makefile.PL", "INSTALLDIRS=vendor", "PREFIX=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system Formula["perl"].opt_bin/"perl", "-e", "require XML::Parser;"
  end
end