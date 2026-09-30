class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/0f/a9/377f71129d200ba59c13870fdd8805ecb7c787eaa25f39bccf230d5b2a34/pipx-1.17.7.tar.gz"
  sha256 "87801dc420c861cb3caf433c52c827745e5bc6ee179a2e4a7021f44b9d7e78a8"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7814d06e45aa63919d8803affb72bb5c62525a7f317835500cca1b517bcc5813"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7814d06e45aa63919d8803affb72bb5c62525a7f317835500cca1b517bcc5813"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7814d06e45aa63919d8803affb72bb5c62525a7f317835500cca1b517bcc5813"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "929c361c14936be0a8d0a5cc89134edbf06364796518e8de1f34b256ba55f2d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "929c361c14936be0a8d0a5cc89134edbf06364796518e8de1f34b256ba55f2d0"
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
    url "https://files.pythonhosted.org/packages/95/31/fbad823d8dfc56e2ff694db0319959382bdb01f2fe40c382e34c6f672392/filelock-4.0.5.tar.gz"
    sha256 "2b155f098c4f285fb41954a22c616c4e8a0635b78c184338ba3023c1c91a4b4d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/c3/8a/84ef03c1c83eacd7cc4540b05428a93b5cd4e42f62fb0b98ac2cb6ed3a6d/platformdirs-4.12.1.tar.gz"
    sha256 "38da801a4af303033cbffccb39030db22bf0473e6414309b02acebeee7ca8bf1"
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