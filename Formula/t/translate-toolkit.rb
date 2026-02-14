class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/6a/a6/7efc98834fb01d3c95548a27334eba76fb8a9fe84b05583dd235f2beb963/translate_toolkit-3.19.0.tar.gz"
  sha256 "ba971762e0e79e216d14ecb857f34749e7361df4a4f309aae82701e7c01ea2f8"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cbf4900f57aeedc8ad7319c843607e568dbd5fc5b1255615190206ce5b1e336e"
    sha256 cellar: :any,                 arm64_sequoia: "37ca4ccee377779c2b0a597c047c5e8082990c4af9c3a5c41b99a3d2ed4d5ac5"
    sha256 cellar: :any,                 arm64_sonoma:  "7a91055ef143dc567d9e1ce18070a59142537b3478e7aa6f6fbeb74f15b77e90"
    sha256 cellar: :any,                 sonoma:        "b83927e045e84732b4990eddbd8d4e1f5f0354f709afcd29dd7b4605b5e9a5d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a96a95e53df7e7c43de9043bca7bd6cba16c3533c85a316e80b23dd40125a539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e05a1fc948bfe50e67653be59560982fc679360d50438637252ee9005fd464"
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