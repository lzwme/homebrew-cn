class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/86/4e/2820045417d94d699c7fcfc81860c9d671aed87fe563a00d9a5f88993c2f/pipx-1.2.0.tar.gz"
  sha256 "d1908041d24d525cafebeb177efb686133d719499cb55c54f596c95add579286"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b7d802d8c4dfe404f0be64c448d6ca335fff429fe1c3cf2534e547702a30a20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44240ace73ffd5a684a05cdc30f332d62c27e0439febfa5a62409f13433a57fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ead2b906e38c1221c546739cd21ac5594cdb0029fd2deb35c242c924b4426d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b577374067228f7a9016e4d3dce43e2fa482b715294b6a4fbb0b8c95d1324eb"
    sha256 cellar: :any_skip_relocation, ventura:        "770f03e469608f39adda33f541699bd5c744c71827eda2c3ba8f7118f8cade35"
    sha256 cellar: :any_skip_relocation, monterey:       "0fbe40b54b52c7ae12f0f7fc758db38007b3a56ab434e7815d93becdf5d8b4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8b13abbbcd60c20adba7685337ee1fa5b75833f1babd93e870fb1eb71d8f073"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/1b/c5/fb934dda06057e182f8247b2b13a281552cf55ba2b8b4450f6e003d0469f/argcomplete-3.1.2.tar.gz"
    sha256 "d5d1e5efd41435260b8f85673b74ea2e883affcbec9f4230c582689e8e78251b"
  end

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
    bin.install_symlink libexec/"bin/register-python-argcomplete"

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipx", "--shell",
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