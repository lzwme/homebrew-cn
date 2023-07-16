class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/7b/b1/7695f743070f369d76b802372faeec7a4ff4a43327d8942c54d5f5091eb9/gallery_dl-1.25.8.tar.gz"
  sha256 "eaad85f73486669d2266806f39422e204a8db3dee16ec6f3136dd72724d95037"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ef933d8eade7e8a4776cbf745ea47a801c0fcf0ad2d01851a71651476e03d16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a523ba7d43036edab470a10fb358904b690b4826c4f36ddb6915c2a7b6df0be5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20d6f5c0ff5017dd0f1de5b2c68117b2303c512762e72906e8a0570637a3d609"
    sha256 cellar: :any_skip_relocation, ventura:        "906ef3181bed7ccaf88ba5158fc3b026ff6f485d989ecbb598123510c0604789"
    sha256 cellar: :any_skip_relocation, monterey:       "e2cb93e66176c4c583d0781cf119dcddc456ca94205e984cd27e2d708e3891d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "20182f30a2fd552253539a502cf7ec0ad834204ff76fae501eb271ab30a255d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ded8a0e084a08b8449a3501be788fc184b3baf4427f1adb831baa0ba690f84b3"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
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
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
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