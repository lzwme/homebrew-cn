class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/32/e5/7cab4af2a0df21555a7b579d21e0b1df34cbe7e089604f04b57ed9496100/translate_toolkit-3.17.5.tar.gz"
  sha256 "036f68bf3dcdd7ca5e59f56f26f26069474a6db31e53460760213045b74539ae"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "511904e04237f85933b21c7c5149dea8f9e3ad51ae2eb45fe26011c0784ef1f0"
    sha256 cellar: :any,                 arm64_sequoia: "ba436f533c35a957cf64b8e19cc82885a59c042d82d11a59ae9e39395184a76d"
    sha256 cellar: :any,                 arm64_sonoma:  "e226c83c43e5674f9e36a54ac19645c51240ef5fb9d3035289ae1edf2bd7406e"
    sha256 cellar: :any,                 sonoma:        "88522bab64cd902546bc079eb4c1489e3438689ab92e1aa1d2a0cf8af437fc6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e36ce07269c4be4e75dadd6b69535f38b4740ebd224fa0c713c12b98c242e43c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a1482f13c194bc1c3a7babff473f8886e8e912066fb39ec4c6f95f3c68bff6c"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/a3/64/009d1e74801a5a38158c11bdb350e7417eb01ed9b1eb45f236154cfa77ce/unicode_segmentation_rs-0.2.1.tar.gz"
    sha256 "ca01aa024a6580960bdab8e4a1a0f1287e9592e66dfdae9e51a1d05f43768e78"
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