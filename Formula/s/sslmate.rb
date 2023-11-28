require "language/perl"

class Sslmate < Formula
  include Language::Perl::Shebang

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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7124d6323deb7b605957235b77286ad7a26ff542e856fb18a3a22568ef5f198e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7124d6323deb7b605957235b77286ad7a26ff542e856fb18a3a22568ef5f198e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7124d6323deb7b605957235b77286ad7a26ff542e856fb18a3a22568ef5f198e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a48ce07dace5cd56870b2eeaa3cb720300314319896ef1234463bd54de52c693"
    sha256 cellar: :any_skip_relocation, ventura:        "a48ce07dace5cd56870b2eeaa3cb720300314319896ef1234463bd54de52c693"
    sha256 cellar: :any_skip_relocation, monterey:       "a48ce07dace5cd56870b2eeaa3cb720300314319896ef1234463bd54de52c693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5c7e9cfc44002529a99466d13cf544d4650488f9989e85973c3b9a78759d68"
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

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"vendor/lib/perl5"

    resources.each do |r|
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