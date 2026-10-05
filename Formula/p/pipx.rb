class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/e9/bf/2cbb3730d2420e39c31214873e37641acd656316cbe9ad94562fb35b21f2/pipx-1.17.11.tar.gz"
  sha256 "7e3d172161ab5c45275cfc04bebf7ce2367d9879d252cf3b29535c4f5e3f607f"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b18f005eff2265b276bca31c0b24c7ef7663101037f38866ed1eb2d399c29e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b18f005eff2265b276bca31c0b24c7ef7663101037f38866ed1eb2d399c29e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b18f005eff2265b276bca31c0b24c7ef7663101037f38866ed1eb2d399c29e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f5faa03f280ef158d264ccfa3d1e8fa6c38de2689dcb9c77b1d9fae592f9c507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f5faa03f280ef158d264ccfa3d1e8fa6c38de2689dcb9c77b1d9fae592f9c507"
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
    url "https://files.pythonhosted.org/packages/4b/51/a182494d1d8dde1240bff84dda57d48165d982e59582ce8f167e8e3d7628/filelock-4.0.10.tar.gz"
    sha256 "00d6a81f976a6332551c2c10f39e12b4abb7e01c64d4c497b81a615bc9186f1f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/42/23/4a86fc741c38c5b69792a4ef954b281afa69bea9f083f881de1b0d23bc07/platformdirs-4.12.3.tar.gz"
    sha256 "427fc0bb321ae0c5b037fa03238ca74820437be162e78b4848c4d4055b9b766c"
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