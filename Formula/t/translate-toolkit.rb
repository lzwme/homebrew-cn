class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/2d/88/3bde2d51413f5f1bc42d96be392d18bd7c313404d93d9a7688d627b2fae9/translate_toolkit-3.18.0.tar.gz"
  sha256 "d31a36733913c83597e7409a932b2eb0ddbc20eb93dbe70eb2d5de34cbc04ec5"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79e37a43a9c4ad622f1bf449b3c2366c0b7b5b0a87eff315164e4a6affcd059a"
    sha256 cellar: :any,                 arm64_sequoia: "88ee5a93581b64dfd5a500d2319e85cecf48c71245b530d97739a2ddb6100f81"
    sha256 cellar: :any,                 arm64_sonoma:  "a3ede4d5ed8fd4c56d16e18f561e4144d09942508e45378ff432647a2438afb7"
    sha256 cellar: :any,                 sonoma:        "981145512f4e0e3aee0badd33fde102a853293e29ea41a67c23f04934bd98ca6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8c3b366cc5b22fe39e9f7d2be54f0f7f31a76a6e5f20e8f5e14b4192fe4e363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06fb244affbf98f942b4e16db5a3647074267e0d48f741f3aa4885e69810033a"
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