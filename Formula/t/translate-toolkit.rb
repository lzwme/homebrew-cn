class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/c5/21/403b9f7586156cb3b606c6d9ae4b52222e592d4559e4a75d322f4dffef36/translate_toolkit-3.19.7.tar.gz"
  sha256 "5de1107a12c2cba4642a32f4fdb6f95b0c474f8540b929377583d53d92958de6"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f57e62b506e1ab957274e9d736e8cecddcab1ebfbe694f36f0c8e61f6cd5d8da"
    sha256 cellar: :any,                 arm64_sequoia: "9ec69af3212046948acfb3ae238a1006c9b034e6f223176187858de69659e68e"
    sha256 cellar: :any,                 arm64_sonoma:  "520ba311be0b05cf19ea9b9678f9370563b28747b2d1bbc573696554a05d8c2a"
    sha256 cellar: :any,                 sonoma:        "0dcffca8f791a915d98c660bb28800028471a6cd5e916eab413445d43966b796"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c009f767e949c30f91a4e7f61c9e3f8a2356820ed64d5f0b896dbab79e480169"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6ebdd35098c5e89ebc03b8599736bb2fb355bf7a9fb4e1f1276c499bb414c3e"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/28/30/9abc9e34c657c33834eaf6cd02124c61bdf5944d802aa48e69be8da3585d/lxml-6.1.0.tar.gz"
    sha256 "bfd57d8008c4965709a919c3e9a98f76c2c7cb319086b3d26858250620023b13"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/15/cd/36adf321a9ba23906f44c1358164d6f69a149350c53802e366a270f7d82c/unicode_segmentation_rs-0.2.4.tar.gz"
    sha256 "d22f419787e77baeac966076d1bf09272cc1087bddfec14f74ce994437d3779d"
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