class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/8e/5a/5c7fc1aca6c2db12379a9a511682dd58ac64bc505792bd84ff1995d594e9/translate_toolkit-3.16.2.tar.gz"
  sha256 "eb63bef9d9aa49901cfa327061694d8cf048d0877198792a9ac6ab1a78828175"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa8a25690d21581f8201d908725af31ffda2a5c38eb17933e7855b14c1f21e62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f771615d0ab5b00b451e47ab60c51b231ab99288a93993f728b27878a7fdc93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3109307c5d5b7ca6440f85c93d37b30fa333ffadd9f7c7bd83e5aaf0f748568f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4149cbde193aa72f94449ccb1fc2d16058a7e446d0cc0172a4f98824bf82c885"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9a3a56f504a81bed5201613e2f9c63f33cff12ab08728cab7421b7372860b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f70d6e9246eb4a1673925a8e631b99f92780a9dcf219a6ff7541344f2c56ba4"
  end

  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
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