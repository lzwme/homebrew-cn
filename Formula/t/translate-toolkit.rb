class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/d8/7a/249a4fe2ebbd857f86156a22e1ddfe9b6f26f46ed1f3f391912ee34eb96b/translate_toolkit-3.19.14.tar.gz"
  sha256 "35874f96ff83188151ee36f01ba1aa24d188151944cd567b85606095171c10d2"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c09b98d98d38c72106b85dc93292a881f7ba14be404e4810615fec7c6ae2d7eb"
    sha256 cellar: :any, arm64_sequoia: "f9323d7593a32e949464f70b4718e4c8fbbfe1679f935409ed2e3e8e4db905e7"
    sha256 cellar: :any, arm64_sonoma:  "9698f1ac4ffdca39b72d6cb5ab845270e7fd4dfa37392ff422a56e788ca61fe2"
    sha256 cellar: :any, sonoma:        "4acd96244d5f94273ffd8ee4cf1c0002d473adfd54053e509cc7c66c353a9385"
    sha256 cellar: :any, arm64_linux:   "864a8a12ee549056142f9bc96370a9501f2d6458f695c408fea1b83b183b4ce8"
    sha256 cellar: :any, x86_64_linux:  "d6e5b398abd61651c90de8a88da37171e2ebc82684497a1a3fdd008897a0d591"
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