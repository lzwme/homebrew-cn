class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/86/4e/2820045417d94d699c7fcfc81860c9d671aed87fe563a00d9a5f88993c2f/pipx-1.2.0.tar.gz"
  sha256 "d1908041d24d525cafebeb177efb686133d719499cb55c54f596c95add579286"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51673f0f9c015e1223d576e30783b07f6cb74829fde195b5a36fc7b0444d3da3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "622ba3224ff4c3e83c2874f0c65aea8c157acc68e42a45d629e33082b83cdd9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bff8d3cbcee0a989030cce191fde69140aac6af84c9e9abeac4ce4dd59bd888"
    sha256 cellar: :any_skip_relocation, sonoma:         "311d8bb68c4add766744a58137f741e223e628877a820fe226429dca90e9ea70"
    sha256 cellar: :any_skip_relocation, ventura:        "b6bbfbd3a993d115f96825c446a6915268f32664e9fe6fa98e3f41928c9073ff"
    sha256 cellar: :any_skip_relocation, monterey:       "cf30fe283884e4f0c372352ace4c1c38473a4ce373b5f84832c0fdcdfa2bdeee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc299aba72faf73cc66b6864ea618c4f64793175753244c18ef44afdb241c2ea"
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
    generate_completions_from_executable(register_argcomplete, "pipx", "--shell",
                                         shells: [:bash, :fish])
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end