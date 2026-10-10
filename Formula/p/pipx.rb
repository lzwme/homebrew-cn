class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/73/c4/45fdc36e7c14b515389dc4a5e9a96ef6e3aa39ef94bd7e2078302e59af12/pipx-1.17.12.tar.gz"
  sha256 "91f9381e7b218ff84b0cdeb79b0b6b4a014e374170a92b5550baba84e212d34a"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c9dff132ec3dec4ac67709c0fe1e8f344dface84522668b61146fdc695a36fad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c9dff132ec3dec4ac67709c0fe1e8f344dface84522668b61146fdc695a36fad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c9dff132ec3dec4ac67709c0fe1e8f344dface84522668b61146fdc695a36fad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "367fb9330de6e2ef8aef726d9dd2beb20531b7f4b1bd0f8e6e392a82ab410855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "367fb9330de6e2ef8aef726d9dd2beb20531b7f4b1bd0f8e6e392a82ab410855"
  end

  depends_on "python@3.15"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/53/e4/34efcb869715cf299e47d1ac7b2624d2bcb6f2d3dffc2f0abe8417f65ab2/filelock-4.0.12.tar.gz"
    sha256 "cf42711a7ac791818b299fab0332a088c65aeeefa36290de98db92c434303b0c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/90/a1/d5f9002a70298c64a789779077d8dd90c10aa1f47fe40c86802df874f2a6/platformdirs-4.12.4.tar.gz"
    sha256 "63743c02414e755de4e31b8f68125c1407495b86c5a006e203c01ff8b9924250"
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