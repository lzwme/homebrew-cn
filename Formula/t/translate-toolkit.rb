class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/dc/8f/618a8b6589e67232feecbda4094fbfa3e076cdabd146519960453ea18b44/translate_toolkit-3.20.1.tar.gz"
  sha256 "8626ab3def40f9db15e0481cf6afcd22aa15f1f12670608a0bcbca57777a2d0c"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "495bc5e1a7f13c870f6bba891110b73cf5adab0c6dc63e5f5e2c6dc2f5d2cc76"
    sha256 cellar: :any, arm64_tahoe:       "0dd909e2479563ac52ad392f8f76f3946f15e3673b20831764ce0ffff6baf1c1"
    sha256 cellar: :any, arm64_sequoia:     "4f9bee581de00c5b65fd401b4fdf81b81dca5556d2b3abe296e1f21ebcca4987"
    sha256 cellar: :any, arm64_linux:       "1bb0aa1c14fa110b72f68f909d766a9c325c41f293a6ad76151eea87710fc689"
    sha256 cellar: :any, x86_64_linux:      "09115e4f61e620feb437584290a8740571601d9ecda605a7b7d4a845be5f6afa"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.15"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/26/e4/28a415f71c7fe00f6b22254b3890442955bc720918c95d7b0c3ea0f5e12b/unicode_segmentation_rs-1.0.0.tar.gz"
    sha256 "0c813bd38ab6bce5176f65d3b7c13b5d771f02dac09c09ff55ceb39728a995ee"
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