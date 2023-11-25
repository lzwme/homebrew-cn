class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.com/gitlint/"
  url "https://files.pythonhosted.org/packages/73/51/b59270264aabcab5b933f3eb9bfb022464ca9205b04feef1bdc1635fd9b4/gitlint_core-0.19.1.tar.gz"
  sha256 "7bf977b03ff581624a9e03f65ebb8502cc12dfaa3e92d23e8b2b54bbdaa29992"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b36e41237bc79a88f0d8ea2ff76004fb814917768d31d22cc4cfc7144ea14856"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c9ed83b9615f97b13fcab06aa6c00312863fa0bbe3426f1ea5b5da7bb1d7ef1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e726076fe33d3ecf17c05881e319fbaa6f6fdc52a012cbcf6d24af094d00d5c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "287142771c90b011d15aed675694735f43e533e50eaf713bc03241d711d16684"
    sha256 cellar: :any_skip_relocation, ventura:        "d48411f02e6844198ff87da6b420ff63182c2b27b4e91232bea9a257c63b0e05"
    sha256 cellar: :any_skip_relocation, monterey:       "7a8d1b29c4ccad5ac3fd9fb1a5742a94d4bbde2aed4f79c63e7e4c6cc2b7b0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3d508fe3488012a9879660f98e74e687d6c34f6fa8596bda0dce119ac8c4421"
  end

  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python@3.12"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/cd/51/7355831d8e1cee8348157d769ccda8a31ca9fa0548e7f93d87837d83866d/sh-2.0.6.tar.gz"
    sha256 "9b2998f313f201c777e2c0061f0b1367497097ef13388595be147e2a00bf7ba1"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  def install
    virtualenv_install_with_resources

    # Click does not support bash version older than 4.4
    generate_completions_from_executable(bin/"gitlint", shells:                 [:fish, :zsh],
                                                        shell_parameter_format: :click)
  end

  test do
    # Install gitlint as a git commit-msg hook
    system "git", "init"
    system "#{bin}/gitlint", "install-hook"
    assert_predicate testpath/".git/hooks/commit-msg", :exist?

    # Verifies that the second line of the hook is the title
    output = File.open(testpath/".git/hooks/commit-msg").each_line.take(2).last
    assert_equal "### gitlint commit-msg hook start ###\n", output
  end
end