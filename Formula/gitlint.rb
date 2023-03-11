class Gitlint < Formula
  include Language::Python::Virtualenv

  desc "Linting for your git commit messages"
  homepage "https://jorisroovers.com/gitlint/"
  url "https://files.pythonhosted.org/packages/73/51/b59270264aabcab5b933f3eb9bfb022464ca9205b04feef1bdc1635fd9b4/gitlint_core-0.19.1.tar.gz"
  sha256 "7bf977b03ff581624a9e03f65ebb8502cc12dfaa3e92d23e8b2b54bbdaa29992"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2ff182766d7e36a8767a2776cbfc29d893eaa41db0b8b316e47b97fc65e415c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09578b908fc814e0d8d43f4629ddff25bc07440d1fe14451e9ba70428701a730"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caaa2531c830499d1c84e7175dfe246f9dfaaaa84fcc0dda09cfff89dd3f2127"
    sha256 cellar: :any_skip_relocation, ventura:        "eae71fbd54573037bf098ffcfae61ae1ad2b5ef7cd1128b5d7fe58152d6db1f2"
    sha256 cellar: :any_skip_relocation, monterey:       "bef2e4b1ee6d9ff969a3056e6b1dbf5e52eddaa694f85de967a8f55171b963ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1b403d54ea9fb7abd33ea796de70d125686e6ce6a3b49e603d52e74255b6e16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9864ef0cc95d169a63f5ab0b4c35c2480e53be11b6787642a3e416e23ae72b3e"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/ff/c7/0c170c7dde31f088f3c8221f90e054b121b5bd36f9e6f94edca4fdb64c0c/sh-2.0.2.tar.gz"
    sha256 "364a25cd2380c3170c46718fe3cc6ffc94b36721e30196a064be508f9b3162f4"
  end

  def install
    virtualenv_install_with_resources
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