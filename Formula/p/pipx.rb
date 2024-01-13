class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https:pipx.pypa.io"
  url "https:files.pythonhosted.orgpackagesff45f5e6b261e2b681c9002aa604f355292f69fd403b004c7a65ca34d4da8f57pipx-1.4.2.tar.gz"
  sha256 "0bead3cbb52674f1b8caa1c04334d6e25aa6c40280b89235bb1f01c20ef1e275"
  license "MIT"
  head "https:github.compypapipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5fb902497ca07e7dba66114635caebca33c8915d72e506ae6a36788740a7e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8623a88a2180fe03eb6fff0a1980f0f01bfbb95b2408ee797b68cc94a2d4f226"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "882b51db85f9e7bb0d5df7c6f09e722e75db935cd34c1614fa994a3671f30856"
    sha256 cellar: :any_skip_relocation, sonoma:         "93c87d57f901bf6a1e014683466cd1fcd97005ebd3a736a8e752543e803b249a"
    sha256 cellar: :any_skip_relocation, ventura:        "4c4d1ad39f01a602844d84338c7680ace285945f29cf554b0e7c5ff2bc488d37"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e61b966929c3a0508105e2fa3d1c92bf8b6b7cc1fc87056144f8d57c64f1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c039b6aa3265a37b0243dbd3f0b57514bc1c832728f6d5dc38f61cb5f16818"
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