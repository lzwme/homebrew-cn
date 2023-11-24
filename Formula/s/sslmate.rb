require "language/perl"

class Sslmate < Formula
  include Language::Perl::Shebang
  include Language::Python::Virtualenv

  desc "Buy SSL certs from the command-line"
  homepage "https://sslmate.com"
  url "https://packages.sslmate.com/other/sslmate-1.9.1.tar.gz"
  sha256 "179b331a7d5c6f0ed1de51cca1c33b6acd514bfb9a06a282b2f3b103ead70ce7"
  license "MIT"
  revision 1

  livecheck do
    url "https://packages.sslmate.com/other/"
    regex(/href=.*?sslmate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "932e9dcb8e0fb10cbc525292fcacab324e5f919e951cdadcee3dd81a1d306c1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "826a25dd77500137cc8305370256fe0f20c4d077f63d68c074ae853eba94a89f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "753c58a81a474c16a65283ce9001695feea621548b94e8c8520bb383bfc7a6b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6259b02b5b9197e69f5efdf546481e16ece92e4b440a071a7ea1c9e372e91542"
    sha256 cellar: :any_skip_relocation, ventura:        "88685486b03263d33975ffd699028b74d5cd91709c546f8fcc57a754ce873242"
    sha256 cellar: :any_skip_relocation, monterey:       "a90a85b45f8b82b2a0dffd3fc4f2d492d8001494cb17ab4904ee8109a6ff21b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f84a12a2650d145b2d6ec14f502de800351aa19fb4b1c013ef7d8e7dd6a0b479"
  end

  depends_on "python@3.12"

  uses_from_macos "perl"

  on_linux do
    resource "URI::Escape" do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.21.tar.gz"
      sha256 "96265860cd61bde16e8415dcfbf108056de162caa0ac37f81eb695c9d2e0ab77"
    end

    resource "Term::ReadKey" do
      url "https://cpan.metacpan.org/authors/id/J/JS/JSTOWE/TermReadKey-2.38.tar.gz"
      sha256 "5a645878dc570ac33661581fbb090ff24ebce17d43ea53fd22e105a856a47290"
    end
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d7/1e/919989cd5ffc34ac7bc1107cca3eb1a9e03bbe05232c5ae61f923ecb689e/boto3-1.29.6.tar.gz"
    sha256 "d1d0d979a70bf9b0b13ae3b017f8523708ad953f62d16f39a602d67ee9b25554"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resource("boto3")

    resources.each do |r|
      next if r.name == "boto3"

      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}/vendor"
        system "make"
        system "make", "install"
      end
    end

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    env = { PERL5LIB: ENV["PERL5LIB"] }
    env[:PYTHONPATH] = ENV["PYTHONPATH"]
    bin.env_script_all_files(libexec/"bin", env)

    rewrite_shebang detected_perl_shebang, libexec/"bin/sslmate"
  end

  test do
    system "#{bin}/sslmate", "req", "www.example.com"
    # Make sure well-formed files were generated:
    system "openssl", "rsa", "-in", "www.example.com.key", "-noout"
    system "openssl", "req", "-in", "www.example.com.csr", "-noout"
    # The version command tests the HTTP client:
    system "#{bin}/sslmate", "version"
  end
end