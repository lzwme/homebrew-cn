class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https:toolkit.translatehouse.org"
  url "https:files.pythonhosted.orgpackagescdea1883a6bb09c1905e6ec60bb641889c41e040c5368229bf92f1b4bd737906translate_toolkit-3.13.2.tar.gz"
  sha256 "f79cc801e94548d2b9f9fd4663c0d48073c34014b92bef542e35da49a6b4c163"
  license "GPL-2.0-or-later"
  head "https:github.comtranslatetranslate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "018a9e899dcee8b196c1603609a74120ddf43fb3d5a9096a7f74ec9fc1e331b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f388e822df7b570da774ab7723cee3b26a6960dab573c5985c1f12d0797d2e19"
    sha256 cellar: :any,                 arm64_monterey: "edf72c22bf08c7e73851c2c387c4db8057dc1b4fa803cf58c779f9e4c0d563bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce1b29d25e9521baf0b7b74541fa495d655ef6d8a56b1ed6fd6e19a44fe2c92a"
    sha256 cellar: :any_skip_relocation, ventura:        "c4d60f5e6f247d0ee6566d54c29b0fee96507a26b31486e5f95f6ee92c72cf4a"
    sha256 cellar: :any,                 monterey:       "237291012a701cbe1638846fba36463aae624d2d6be63f657056fd31bb5e4d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97ff2c460b7d37b91013d7f8b108243c93602c3d7c95edcf4fdabd020e1eebef"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages63f7ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055blxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}podebug --version")
  end
end