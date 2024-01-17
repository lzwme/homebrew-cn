class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https:pipx.pypa.io"
  url "https:files.pythonhosted.orgpackagesc68e63d1bb26319d0fbb44b21fc068a7c0dab96e8516fbb2dd5f572f7ad178d2pipx-1.4.3.tar.gz"
  sha256 "d214512bccc601b575de096ee84fde8797323717a20752c48f7a55cc1bf062fe"
  license "MIT"
  head "https:github.compypapipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "641eac15d9fcb26cd6db761aa147c018296d9c19738b44b8fac0616e8150c2dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e55efb7fe96ce4541390f0b39ac77598ad0ff105bf15c35b90c34d0f28e82b3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe4686b8dd3acd4979180dfce1e6d1f80fb6de5d6bda0020ffc9c8749156f99"
    sha256 cellar: :any_skip_relocation, sonoma:         "c22b9432447390a60dc231194fb119a6d9ca65387655c835e3a8a2aab34f26f1"
    sha256 cellar: :any_skip_relocation, ventura:        "4c61cca5d6d34fed5c5cff8a537aace76c964eaca1bfaa1eab3959ae6ac3cb53"
    sha256 cellar: :any_skip_relocation, monterey:       "4a2b72f8da1aad0ef69f5b4ec9ee08a52dc8fb8d408745a81b58299d1b5faa3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf7a3b6c37aad7a960f25a36c384f8d84a3ad1f88259110112d04e342a9047e1"
  end

  depends_on "python-argcomplete"
  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages62d17feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9aplatformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "userpath" do
    url "https:files.pythonhosted.orgpackages4d13b8c47191994abd86cbdb256146dbd7bbabcaaa991984b720f68ccc857bfcuserpath-1.9.1.tar.gz"
    sha256 "ce8176728d98c914b6401781bf3b23fccd968d1647539c8788c7010375e02796"
  end

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "srcpipxinterpreter.py",
              "DEFAULT_PYTHON = _get_sys_executable()",
              "DEFAULT_PYTHON = '#{python3.opt_libexec"binpython"}'"

    virtualenv_install_with_resources

    register_argcomplete = Formula["python-argcomplete"].opt_bin"register-python-argcomplete"
    generate_completions_from_executable(register_argcomplete, "pipx", shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}pipx --help")
    system bin"pipx", "install", "csvkit"
    assert_predicate testpath".localbincsvjoin", :exist?
    system bin"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}pipx list")
  end
end