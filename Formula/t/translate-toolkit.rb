class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/82/86/4135086b9c268a2ba0bc2f1d40bb5723361441f02cb9dcff262b44817e43/translate_toolkit-3.19.16.tar.gz"
  sha256 "93182ec4e922e2f0e51e9a788d0d164faf4c8d10f1e47fa98c22226bd92b529e"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1aa415efe73af79cc0e053a3a96c25e6f7b43d86da404b299935f0365dec5e5b"
    sha256 cellar: :any, arm64_sequoia: "c5b35247bb770f34306fff953d8522190e425337a97aef52900b1bbdbf225a0a"
    sha256 cellar: :any, arm64_sonoma:  "84a71ceca307917725d6be8ca1b6f4bd9c7de6100cd8891595686f82f6b7d02f"
    sha256 cellar: :any, sonoma:        "728a028e057577a9779034b03e0c6ea9c883965bc0cf2791751fe97ade0e0a89"
    sha256 cellar: :any, arm64_linux:   "caf32b6b7f589b630429dfcb6861931a3d6775ab351e7f64e7a009c52d4f6d41"
    sha256 cellar: :any, x86_64_linux:  "053ae0367afdb0bee2fee61fb5a3969a287480713d275515f78d3c9e96bf9d1b"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/27/23/2b8888406ad5d178edbdb6efcc55740b7c307077800a705632771d34031a/unicode_segmentation_rs-0.3.1.tar.gz"
    sha256 "f7e852f8bf3dfa9073aec148d13d239fa2597b804a3e6ff51050beb59bb79a6e"
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