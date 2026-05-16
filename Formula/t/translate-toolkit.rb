class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/1e/19/6af0158c320a6df71072a813dc65347ca156bc69cc94204c8d7784c52f20/translate_toolkit-3.19.10.tar.gz"
  sha256 "d996eb0e802c1c854468c5dca52343e620ab107c803fb82090c130730763b76a"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b38365b95170fa8dcbf20adeb5a79184e15cee0083883549c79444526e31b91d"
    sha256 cellar: :any,                 arm64_sequoia: "341972965e5471c249634d4a788bfeb5534fb836b763fce4755a560543aaade9"
    sha256 cellar: :any,                 arm64_sonoma:  "4bba67a69dfac3ca6b350a06039e8954e8c3ac59de9b8e63703cd1be91820865"
    sha256 cellar: :any,                 sonoma:        "8ed93bee40b37738e07828f0d0953cf30d4acf87b07c31401f3f423c3fdd2751"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ee55266bcc7d96a61fe8a50630dcbe8105beae39a87cba7b3dffe5ef2fd6b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1804dbf5e16a9763705a48a70a2bab609e8209acc1841aee73ba30ad36504779"
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