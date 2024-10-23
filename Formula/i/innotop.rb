class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https:github.cominnotopinnotop"
  url "https:github.cominnotopinnotoparchiverefstagsv1.13.0.tar.gz"
  sha256 "6ec91568e32bda3126661523d9917c7fbbd4b9f85db79224c01b2a740727a65c"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 10
  head "https:github.cominnotopinnotop.git"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a17005507753da73e8a13a96b378233d51dd27cc395eecbbf71fd7206bc40acf"
    sha256 cellar: :any,                 arm64_sonoma:  "49218a88a5c4b0bc005ca1dd974b408551dacad3514bf86c99635f96da787393"
    sha256 cellar: :any,                 arm64_ventura: "cf8f414fe93aa6ab94e1b8f56abec847fce802bd9774d64eae50a1fc4dc6e1e3"
    sha256 cellar: :any,                 sonoma:        "df181fa1cebc759da9f19b1c67977842b505195301a3a37b82f745f8b7217753"
    sha256 cellar: :any,                 ventura:       "4ab714cc8fea0aa2936abe48a665f2e66ce0516e8dfff847be69b105402db2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5983d9ca80837dcc86692cb8a9a17963543cd71ad3cb599887cbc47a600840e"
  end

  depends_on "mysql-client"
  depends_on "openssl@3"

  uses_from_macos "perl"

  on_macos do
    on_intel do
      depends_on "zstd"
    end

    depends_on "zlib"
  end

  resource "Devel::CheckLib" do
    url "https:cpan.metacpan.orgauthorsidMMAMATTNDevel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    url "https:cpan.metacpan.orgauthorsidTTITIMBDBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https:cpan.metacpan.orgauthorsidDDVDVEEDENDBD-mysql-5.008.tar.gz"
    sha256 "a2324566883b6538823c263ec8d7849b326414482a108e7650edc0bed55bcd89"
  end

  resource "Term::ReadKey" do
    on_linux do
      url "https:cpan.metacpan.orgauthorsidJJSJSTOWETermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    inreplace "innotop", "#!usrbinenv perl", "#!usrbinperl"

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix"man"
    bin.env_script_all_files(libexec"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}innotop --version")
  end
end