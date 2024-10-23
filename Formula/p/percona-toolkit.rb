class PerconaToolkit < Formula
  desc "Command-line tools for MySQL, MariaDB and system tasks"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/3.6.0/source/tarball/percona-toolkit-3.6.0.tar.gz"
  sha256 "48c2a0f7cfc987e683f60e9c7a29b0ca189e2f4b503f6d01c5baca403c09eb8d"
  license any_of: ["GPL-2.0-only", "Artistic-1.0-Perl"]
  revision 2
  head "lp:percona-toolkit", using: :bzr

  livecheck do
    url "https://docs.percona.com/percona-toolkit/version.html"
    regex(/Percona\s+Toolkit\s+v?(\d+(?:\.\d+)+)\s+released/im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1134b153a117ab438762c198f47170b24eb8b09aa4bc5eecfd0c5511dc6e8e4"
    sha256 cellar: :any,                 arm64_sonoma:  "5f0de6236a3b694a6d6789fd33546ccbbf7fafd3926f6c428693c67bfba1c6de"
    sha256 cellar: :any,                 arm64_ventura: "b2946e3784bab092642da4a5031e9ca0607accd6952584d026c5b00b46e2bee6"
    sha256 cellar: :any,                 sonoma:        "6d42bf7568d502d97272e1ebbf7a3cf5c7b996b46d028310acdcf38ad0cb601a"
    sha256 cellar: :any,                 ventura:       "7f01e906b9474648465bb533e93ed918b27f295e6ad00b056e0ce03b1687c829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ebe3d5dc418029eb174269d47e4b2d7f74bff8581f11653b5de8b48a6514a00"
  end

  depends_on "go" => :build
  depends_on "mysql-client"

  uses_from_macos "perl"

  # Should be installed before DBD::mysql
  resource "Devel::CheckLib" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MATTN/Devel-CheckLib-1.16.tar.gz"
    sha256 "869d38c258e646dcef676609f0dd7ca90f085f56cf6fd7001b019a5d5b831fca"
  end

  resource "DBI" do
    url "https://cpan.metacpan.org/authors/id/T/TI/TIMB/DBI-1.643.tar.gz"
    sha256 "8a2b993db560a2c373c174ee976a51027dd780ec766ae17620c20393d2e836fa"
  end

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/D/DV/DVEEDEN/DBD-mysql-5.008.tar.gz"
    sha256 "a2324566883b6538823c263ec8d7849b326414482a108e7650edc0bed55bcd89"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-4.10.tar.gz"
    sha256 "df8b5143d9a7de99c47b55f1a170bd1f69f711935c186a6dc0ab56dd05758e35"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath/"build_deps/lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    build_only_deps = %w[Devel::CheckLib]
    resources.each do |r|
      r.stage do
        install_base = if build_only_deps.include? r.name
          buildpath/"build_deps"
        else
          libexec
        end

        make_args = []
        make_args << "OTHERLDFLAGS=-Wl,-dead_strip_dylibs" if r.name == "DBD::mysql" && OS.mac?

        system "perl", "Makefile.PL", "INSTALL_BASE=#{install_base}", "NO_PERLLOCAL=1", "NO_PACKLIST=1"
        system "make", "install", *make_args
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}", "INSTALLSITEMAN1DIR=#{man1}"
    system "make", "install"
    bin.env_script_all_files(libexec/"bin", PERL5LIB: libexec/"lib/perl5")
  end

  test do
    input = "SELECT name, password FROM user WHERE id='12823';"
    output = pipe_output("#{bin}/pt-fingerprint", input, 0)
    assert_equal "select name, password from user where id=?;", output.chomp

    # Test a command that uses a native module, like DBI.
    assert_match version.to_s, shell_output("#{bin}/pt-online-schema-change --version")
  end
end