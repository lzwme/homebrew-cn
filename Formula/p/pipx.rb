class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https:pipx.pypa.io"
  url "https:files.pythonhosted.orgpackagesfa0acdbfa925343ace5e2f8fbfdac97822efe1da8d89fa2782b56f400560860bpipx-1.3.3.tar.gz"
  sha256 "6d5474e71e78c28d83570443e5418c56599aa8319a950ccf5984c5cb0a35f0a7"
  license "MIT"
  head "https:github.compypapipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31547c41734fa46c13276ada25e3e8548db97281d0c513b9cdcb5268adcc74ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd3ecf45912d719ee4c36ad1a98540b6e0361c60e708e64a48c2d3d3d62e082f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54a029fa1856237f74ff644fd901c928d8ba95d3044844f74f544f68975699ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "be78825c9cdc8bda19000f2e5acedeeaad92770dd4d6d743760d5f0c86eef5bd"
    sha256 cellar: :any_skip_relocation, ventura:        "e20f9f8e3068c6f5efe317f0ad16763d8f56bc6af2929992379479b5a19c8eda"
    sha256 cellar: :any_skip_relocation, monterey:       "df38fb53c63105f6ea6cf4ed535a85359b4490940066b42cfcda02ded88982aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a8f0dce87e7bd66f06f18f3cec33f13d69424d8710927ba8c37d45ee941ae06"
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