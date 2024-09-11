class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https:pipx.pypa.io"
  url "https:files.pythonhosted.orgpackages1721dd6b9a9c4f0cb659ce3dad991f0e8dde852b2c81922224ef77df4222ab7apipx-1.7.1.tar.gz"
  sha256 "762de134e16a462be92645166d225ecef446afaef534917f5f70008d63584360"
  license "MIT"
  head "https:github.compypapipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "eb9543f8890a6a9bfc7e6a6c04b7224d4197462792c2c7b9fde167ba388453b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35878f2b4360c9cb25d27d2eb81a8a954bf6b80aafe4b8d9b8a163682f38b59e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35878f2b4360c9cb25d27d2eb81a8a954bf6b80aafe4b8d9b8a163682f38b59e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35878f2b4360c9cb25d27d2eb81a8a954bf6b80aafe4b8d9b8a163682f38b59e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c33bf8044831c9db99aa7ebff0efe88f20274736af0f890d669a0d0c5693a1e9"
    sha256 cellar: :any_skip_relocation, ventura:        "c33bf8044831c9db99aa7ebff0efe88f20274736af0f890d669a0d0c5693a1e9"
    sha256 cellar: :any_skip_relocation, monterey:       "c33bf8044831c9db99aa7ebff0efe88f20274736af0f890d669a0d0c5693a1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d6ef23a8c681bc0139299af75742d125411faf69d9ddaf57bfa15c935c27e58"
  end

  depends_on "python@3.12"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7533a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "userpath" do
    url "https:files.pythonhosted.orgpackagesd5b730753098208505d7ff9be5b3a32112fb8a4cb3ddfccbbb7ba9973f2e29ffuserpath-1.9.2.tar.gz"
    sha256 "6c52288dab069257cc831846d15d48133522455d4677ee69a9781f11dbefd815"
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

    generate_completions_from_executable(libexec"binregister-python-argcomplete", "pipx",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}pipx --help")
    system bin"pipx", "install", "csvkit"
    assert_predicate testpath".localbincsvjoin", :exist?
    system bin"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}pipx list")
  end
end