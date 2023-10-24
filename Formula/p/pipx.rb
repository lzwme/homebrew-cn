class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/f7/fc/a7d0af355ad074872c9fe282cb2877acb3395cfa3ec044d7c032031f6ae5/pipx-1.2.1.tar.gz"
  sha256 "698777c05a97cca81df4dc6a71d9ca4ece2184c6f91dc7a0e4802ac51d86d32a"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "debeab71ad334251712228fa2040f9b2098b8cecd15ceccfeb0d711dd2f049c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d1974f6b6a99e2ac4e0a78382aadefdc8e4caaca2936923ce89058c9bc311d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4318481332018a8a2fa78d127df329743cbd54b8ce73eeb5d0e78c28326dda5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4711d69030c0a6aa90cd95e013dfc11a47399a37d57d7e6ab414a6f96648503b"
    sha256 cellar: :any_skip_relocation, ventura:        "66c838eb9adca857b9678a577f76daaf5f7dcb91acb064286bff1d0a42623a6f"
    sha256 cellar: :any_skip_relocation, monterey:       "1715d6c22088a7b18dda60d6bc9a79e817f6c5adbd7ee97c855d155417cd359e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e804f64ddeb976d60f39efd2fb5ea8a3e921ce4585f0b50e6bf0f0dc5b56f9b3"
  end

  depends_on "python-argcomplete"
  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/4d/13/b8c47191994abd86cbdb256146dbd7bbabcaaa991984b720f68ccc857bfc/userpath-1.9.1.tar.gz"
    sha256 "ce8176728d98c914b6401781bf3b23fccd968d1647539c8788c7010375e02796"
  end

  def install
    virtualenv_install_with_resources

    register_argcomplete = Formula["python-argcomplete"].opt_bin/"register-python-argcomplete"
    generate_completions_from_executable(register_argcomplete, "pipx", shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end