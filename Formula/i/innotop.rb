class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https:github.cominnotopinnotop"
  url "https:github.cominnotopinnotoparchiverefstagsv1.13.0.tar.gz"
  sha256 "6ec91568e32bda3126661523d9917c7fbbd4b9f85db79224c01b2a740727a65c"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 6
  head "https:github.cominnotopinnotop.git"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ebac90fa631d9aaf0e8f388db5c7f2b5199884822792d1e8b4426e27544e969"
    sha256 cellar: :any,                 arm64_monterey: "64e15253d62337db2f0ec1be9c7d33f9a67325df905d4a6490f24e41465b401f"
    sha256 cellar: :any,                 ventura:        "0c8ff89b827aa1925b6aa607ea4ae518fc8c5b253742e33f801066b04432acac"
    sha256 cellar: :any,                 monterey:       "a0a0f1e3750a70f93fca1e3b99bd0eca0893f2dc767acf0cb0e0f96733897e1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5331cfdb419c2669ad272183abccd8e622e182b863e156b2bf5a8634d84a28d"
  end

  depends_on "mysql-client"
  depends_on "openssl@3"

  uses_from_macos "perl"

  resource "Devel::CheckLib" do
    url "https:cpan.metacpan.orgauthorsidMMAMATTNDevel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    url "https:cpan.metacpan.orgauthorsidTTITIMBDBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https:cpan.metacpan.orgauthorsidDDVDVEEDENDBD-mysql-5.002.tar.gz"
    sha256 "8dbf87c2b5b8eaf79cd16507cc07597caaf4af49bc521ec51c0ea275e8332e25"
  end

  resource "TermReadKey" do
    url "https:cpan.metacpan.orgauthorsidJJSJSTOWETermReadKey-2.38.tar.gz"
    sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        # Work around restriction on 10.15+ where .bundle files cannot be loaded
        # from a relative path -- while in the middle of our build we need to
        # refer to them by their full path.  Workaround adapted from:
        #   https:github.comfinkfink-distributionsissues461#issuecomment-563331868
        inreplace "Makefile", "blib", "$(shell pwd)blib" if OS.mac? && r.name == "TermReadKey"
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