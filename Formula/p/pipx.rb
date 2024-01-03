class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https:pipx.pypa.io"
  url "https:files.pythonhosted.orgpackagesa9d451d073bec8b1cab9e3536b49964d6e6e541d202ea964e800695c0514b9eepipx-1.4.1.tar.gz"
  sha256 "ccb78fa8dc4ae91f1e8d7c6f04d47a29fa045d312cd37c2b0bcc74dd8353b675"
  license "MIT"
  head "https:github.compypapipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eac6bc2f2132e4725d61f4566a2e6a6503bafa61b7e05f970d3aacc25c0bd70f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d30f930f8b5948a35004b205ed3b263a5285c3cd9a17e4348b47637686853ff3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85d0309f0e0b183b548d4935fee8c3cb820efcb048c1336f4040629caea4e77"
    sha256 cellar: :any_skip_relocation, sonoma:         "332df41c9c3b9306ea2efefce1648b282e3e374cabcaf831c18f4868387595cb"
    sha256 cellar: :any_skip_relocation, ventura:        "ab40463ae5d43f6e93b4f6e0d34a6e751f7279b0b7eae6c2ef7427b69ebe72b6"
    sha256 cellar: :any_skip_relocation, monterey:       "98f82cc4491df61f5cddd0cd515ba8df6856fe5c7d761bdf9083aaa43a34b43f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "109aaeed2cfea5ebc59bd142cc84ff590f3f49eaaf70bfcc3e44439b9fedba07"
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