class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/69/b6/343c1c1420d248aef3dc932ab92f2b8669f3fc5df06cddf8a5558d899fc9/pipx-1.17.10.tar.gz"
  sha256 "efee1bf02ac4533c5d6c4e1432f5e769599b6d80de43b828c45629dd9a674469"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b8b7918f092c2bdb82e591ec113fa70196e336bcf3133ec0db99ad370c56ba0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3b8b7918f092c2bdb82e591ec113fa70196e336bcf3133ec0db99ad370c56ba0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b8b7918f092c2bdb82e591ec113fa70196e336bcf3133ec0db99ad370c56ba0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "71352f3ec0c3f6acad8c41cb879bbc2c5f710ae9cdd46f2e6336394610985bc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "71352f3ec0c3f6acad8c41cb879bbc2c5f710ae9cdd46f2e6336394610985bc6"
  end

  depends_on "python@3.14"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/51/2bc9e529f154fad99b6cd0073e609291eb32fd23581b32362d33d164d316/filelock-4.0.9.tar.gz"
    sha256 "635e7d67fa92654eed444e75e9ca18426d34e77ad9c469bf4373f75a932f7b22"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/17/c8/721b3855fe457da514fe249247d404b9b39c5d16532278f70ebaa6acf18b/platformdirs-4.12.2.tar.gz"
    sha256 "eab5f70271a490ef74618bb314fbb86e3c7e82fa3b9c922c2ea0e0a1a155d329"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/d5/b7/30753098208505d7ff9be5b3a32112fb8a4cb3ddfccbbb7ba9973f2e29ff/userpath-1.9.2.tar.gz"
    sha256 "6c52288dab069257cc831846d15d48133522455d4677ee69a9781f11dbefd815"
  end

  # downloads wheels during build and test
  deny_network_access! :postinstall

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "src/pipx/interpreter.py", "return _get_sys_executable()",
                                         "return '#{python3}'"

    venv = virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipx",
                                         shell_parameter_format: :arg)

    # Build an `:all` bottle by replacing comments
    file = venv.site_packages.glob("argcomplete-*.dist-info/METADATA")
    inreplace file, "/opt/homebrew/bin/bash", "$HOMEBREW_PREFIX/bin/bash"
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_path_exists testpath/".local/bin/csvjoin"
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end