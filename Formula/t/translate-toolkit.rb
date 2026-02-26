class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/2c/b0/2a9ad6401f1b46af7a2c84ab5a4f254dbe50f4e962b2e4de6dfb18b61e1d/translate_toolkit-3.19.2.tar.gz"
  sha256 "8ebd778070de9bbe243de6216f172573f6564b09649fb45029d92022907e7446"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ecb5bb488518d81ce9e870772ea1923b244542c28b5711f63cfd020a8c6b189c"
    sha256 cellar: :any,                 arm64_sequoia: "58266f525f033b8d24033e08f563b2d57b9ffd2f2e99a073e84dcded28374846"
    sha256 cellar: :any,                 arm64_sonoma:  "5bf8d49660647d397e7954726950e37b93173f61c473af543bfe03eb3e377b0a"
    sha256 cellar: :any,                 sonoma:        "4d1734087e7920459f7821aa324a9385d81a02fe7e8b5cf7635b69a50c3a9254"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19912cf3ae1fb783029de63e1bf665a500048add799d3d5fc8e6b0fb1573d318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1f89f265ad07b60fb9db415c854cc613da5c6c4e272463ca5ea88e3435c875d"
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