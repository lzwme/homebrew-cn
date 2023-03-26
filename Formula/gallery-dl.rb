class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/1f/c4/8b6b44fb92eb6d8c03790db998926028b25c7bc49712a7c63eba1e627df4/gallery_dl-1.25.1.tar.gz"
  sha256 "bacf65cdc85db020f8b18e174357f88f7c0ab85b4466712e06b9526b71690cfe"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e81ee414ad57a7097229dead6ff31eb7a76e0e94411c861ce52a3b766d0900e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a1b9b5381119d456faee0d8fd5b308f92b1e79ebc738e9790910f99b6b59c5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de1dd5164d6441ee83878bb3857f9db984a6236eba781b869c3502691521018e"
    sha256 cellar: :any_skip_relocation, ventura:        "d10fbdc796ea9adbb8a1b556d59acb3b32d013a10d94abe3d5ba279b63da2e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "98720a3e8bfb9c7a49a62cca142814d536d5da91a0b316d5920ecb5e7a327322"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba80f421db0a39992b16c9f89f4d28b633c6dfda703d97b75388ebdba9200d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5794271a4c1a29608ff37ab7c05bb5cb7bb37636c39e6fd8d26de25fcf9ff639"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
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