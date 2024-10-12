class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https:github.commikfgallery-dl"
  url "https:files.pythonhosted.orgpackagesf09fe67b9635bf24b287f2f985a50ae6ca9e278edabe34adb94a8d0918c61e94gallery_dl-1.27.6.tar.gz"
  sha256 "6f1875e5a648ba94da1e760ceb930062e62d2b1d33d8e21097758a114d603b84"
  license "GPL-2.0-only"
  head "https:github.commikfgallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f771e430eaa9b8f8500ddf6fe6a2b12515577633d1da9ed898d8701dee01d5d"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    system "make", "man", "completion" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec"sharemanman1gallery-dl.1"
    man5.install_symlink libexec"sharemanman5gallery-dl.conf.5"
    bash_completion.install libexec"sharebash-completioncompletionsgallery-dl"
    zsh_completion.install libexec"sharezshsite-functions_gallery-dl"
    fish_completion.install libexec"sharefishvendor_completions.dgallery-dl.fish"
  end

  test do
    system bin"gallery-dl", "https:imgur.comadyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath"gallery-dlimgurdyvohpFimgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end