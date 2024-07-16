require "languageperl"

class PerconaToolkit < Formula
  include Language::Perl::Shebang

  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https:www.percona.comsoftwarepercona-toolkit"
  url "https:www.percona.comdownloadspercona-toolkit3.6.0sourcetarballpercona-toolkit-3.6.0.tar.gz"
  sha256 "48c2a0f7cfc987e683f60e9c7a29b0ca189e2f4b503f6d01c5baca403c09eb8d"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https:docs.percona.compercona-toolkitversion.html"
    regex(Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+releasedim)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3578967f724fef85f292ae43e6b5762730a6c0db221dedd0b6886018e3f6dc7e"
    sha256 cellar: :any,                 arm64_ventura:  "fedea0308876d20e3ffd0453b23cbdc4cb71f51f9990963aaffb6a04e809aa77"
    sha256 cellar: :any,                 arm64_monterey: "1412034cc58a4ac8712a1481ffdf9234f3837da567295fe0acd57fefdfe3b2f8"
    sha256 cellar: :any,                 sonoma:         "7d35d44dff1d954d3fbf9d4452ba6b93308837f150437515861a39ce077ab9da"
    sha256 cellar: :any,                 ventura:        "d8b7919ca242c8c1773fb1166549cdc97ea9460649eaf16d257bd679750ff6a6"
    sha256 cellar: :any,                 monterey:       "0a353fd7fb6a77c36e9569e4a8bcf404dc7f222e35f47871bab9db4538bce75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a804d1373224eb2c109497752b9e276ac0ee9eb3acdd50d5e9d416587bd242d1"
  end

  depends_on "go" => :build
  depends_on "mysql-client"
  depends_on "openssl@3"

  uses_from_macos "perl"
  uses_from_macos "zlib", since: :sonoma

  on_intel do
    depends_on "zstd"
  end

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https:cpan.metacpan.orgauthorsidMMAMATTNDevel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    url "https:cpan.metacpan.orgauthorsidTTITIMBDBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https:cpan.metacpan.orgauthorsidDDVDVEEDENDBD-mysql-5.007.tar.gz"
    sha256 "5b943a86e6130885068088c5b6f97803a96b2b5cab8433bbd6beb98478ad1b3a"
  end

  resource "JSON" do
    url "https:cpan.metacpan.orgauthorsidIISISHIGAKIJSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath"build_depslibperl5"
    ENV.prepend_create_path "PERL5LIB", libexec"libperl5"

    build_only_deps = %w[Devel::CheckLib]
    resources.each do |r|
      r.stage do
        install_base = if build_only_deps.include? r.name
          buildpath"build_deps"
        else
          libexec
        end
        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}", "NO_PERLLOCAL=1", "NO_PACKLIST=1"
        system "make", "install"
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix"man"

    # Disable dynamic selection of perl which may cause segfault when an
    # incompatible perl is picked up.
    # https:github.comHomebrewhomebrew-coreissues4936
    rewrite_shebang detected_perl_shebang, *bin.children

    bin.env_script_all_files(libexec"bin", PERL5LIB: libexec"libperl5")
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp

    # Test a command that uses a native module, like DBI.
    assert_match version.to_s, shell_output("#{bin}pt-online-schema-change --version")
  end
end