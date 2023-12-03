class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/2c/e0/8aeefc5c784b5b5cf9db979619963fef880a9a9f8718f5558fbd203dc294/pipx-1.3.1.tar.gz"
  sha256 "34d4a313eaeefe3d506b8e7cb75752fda970ec76774cfd774d1e2a7076cef60f"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05b993baf897f284bddf60259d393fbbc212abeeb271b1dbee8a7b12fa104a50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abfb7d2ecb188d721c9508a9c5da84d2b3cfd0e50c0fdc6047b34e5dc6a06ec4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b4ab0640d3e74962b5bfbaa22f6cb3eb20a6f41f164984a3e7719151a6b0fa5"
    sha256 cellar: :any_skip_relocation, sonoma:         "02d74ce75d95153f5bb67a96a209125bf33ad1e512fba094fc2091c1dcaa80e5"
    sha256 cellar: :any_skip_relocation, ventura:        "588a20806e95f797bab24a2900f00bd3291a9193d147463bd705da9eb0ada55e"
    sha256 cellar: :any_skip_relocation, monterey:       "9fdeec06b17c63c2543861536af95998262d165c27626d979f0e85b04be0ba23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f113f0bc2b0cb165ea21789a75c36b19f331d88d1f17bea24ba3bfbe76400eb4"
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