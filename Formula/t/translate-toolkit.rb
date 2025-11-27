class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/c0/7a/f3e022443bf110271a5a63e538da9f00dff381a0e81f0feff380ab8f09d8/translate_toolkit-3.17.0.tar.gz"
  sha256 "c842ce7f0d8ea92feec849f33328963121fc3896ba6fe382fd77d99d650d2f77"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "831d30dccb3ef848395098312d245a3fa35e6ac0e88ac49c52ec10922c610667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ff5f8c4d344902487841221164ec2c81f9cdaa93182f9369b851fa91b39abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee9ed2e6cd0eaab3892af4e0cbea19f3870509598274c6ab3e472ac3d0c5baee"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d1929c15199c07d3bc0a28ed206a65181d12319b071304dba779d52bd3f6b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd4143c1f3fd820524b8fbee54c75fc6c222429ea17242f4f60ac2ae1280263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aecec91a191856d1061249bf15ebcc38a625a9c395c016e72d4c07200a5cb20c"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "uniseg" do
    url "https://files.pythonhosted.org/packages/26/9e/179eab698c565904a25bf0d8c999ef7ec858c9828809df2d1a5b92a5dd67/uniseg-0.10.0.tar.gz"
    sha256 "b5ea258b3a21bfe9ce1adde56836c0d055743a69aba44cb9d3596bda4f0c52a3"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end