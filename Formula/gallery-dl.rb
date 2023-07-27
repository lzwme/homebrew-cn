class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/7b/b1/7695f743070f369d76b802372faeec7a4ff4a43327d8942c54d5f5091eb9/gallery_dl-1.25.8.tar.gz"
  sha256 "eaad85f73486669d2266806f39422e204a8db3dee16ec6f3136dd72724d95037"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cde347e133715c1cda93f8d73ae81ffbc7899ead41697ee73c7046b3e9115e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e71a5b4c6b888f5edb545e58214239314f5f553149fa9a91b4e85d425a71ce0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e19519cac80490cd7602fb649f3c7fa32f8a8e95d3fe9b06bff4cc11f31ccb1"
    sha256 cellar: :any_skip_relocation, ventura:        "086a2a55862f13d7576207ce6338b5bf703950ed2cb395f98eae6dc1ca43245c"
    sha256 cellar: :any_skip_relocation, monterey:       "524f1a91ba4062dd6e073f65f4523d8b9ae8885a8388d5fe99c3f907b2427827"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1e15c23a70318e635bcbdc60f8e82825372f86157d2a0fc0050adb9035b1fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a407f0a842d7f71ad4248dc7f59ed05849a8b8e99f92b283eed7fdd5dbbff00f"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end