class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/33/00/61dda1c724a8a686cb7f3dffb2ea163a5b53bd306974caca65cefd6c9e59/pipx-1.3.2.tar.gz"
  sha256 "704d01d04c67c2dd0c776c5bf5ed35c7b249055b0174568b8507f07d72ed7a7f"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7be1a6e5af8e42e5e48061b8878d2964cfb22d64eb539a7b16ee1b308d5dda07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3525b052fd23af580d0cd204b1f83676a3c62fabae30a55b9123cf0c1144a5e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df2995d4ab82318fbfa6e2d6eb1b990be1890d0d9b6f5a53eda13141177f49c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb59ee5e8bd44c75e39a15457acb34c31a43460bdb825eb3334e6646bb5e0e38"
    sha256 cellar: :any_skip_relocation, ventura:        "2e291cb47aba172ff517b7832ffded11e8d5dd2b142ef51fcd763d9e88071051"
    sha256 cellar: :any_skip_relocation, monterey:       "a3c3d4c0736f0fa7512db992c428cc8a9ede133b193bd410c939074472b70ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72eef8792c20f9026e581a3df3ea6fc328da415899274aa3f97c2f329673169f"
  end

  depends_on "python-argcomplete"
  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/31/28/e40d24d2e2eb23135f8533ad33d582359c7825623b1e022f9d460def7c05/platformdirs-4.0.0.tar.gz"
    sha256 "cb633b2bcf10c51af60beb0ab06d2f1d69064b43abf4c185ca6b28865f3f9731"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/4d/13/b8c47191994abd86cbdb256146dbd7bbabcaaa991984b720f68ccc857bfc/userpath-1.9.1.tar.gz"
    sha256 "ce8176728d98c914b6401781bf3b23fccd968d1647539c8788c7010375e02796"
  end

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "src/pipx/interpreter.py",
              "DEFAULT_PYTHON = _get_sys_executable()",
              "DEFAULT_PYTHON = '#{python3.opt_libexec/"bin/python"}'"

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