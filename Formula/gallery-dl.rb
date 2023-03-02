class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/60/f0/2272e1002f1f16446af3c68aa46d35462fa22f0890ed10f22e53c4f0cda8/gallery_dl-1.24.5.tar.gz"
  sha256 "3fbd4988623d3e958c025824e53c106bf87701411948467afcc6a163e208cbd3"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2628d30ea873b9e83eb61b3113b3dd83b54de1e4fffdb636ccbf7851318ac15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3480e607022c51ecfcdd2efa99e1177f2e45742dd398c7ac311416261c5a086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30768d7fd91c258cc3aedd3351a34d20f023965cb1303ef33a9612623a7f8c8c"
    sha256 cellar: :any_skip_relocation, ventura:        "02351345f936f0e764cea167f5ca068827a2d51b25a16ed4f27229200ff4b506"
    sha256 cellar: :any_skip_relocation, monterey:       "ad2abb1ff82b2706b4c3e24c2246613ee558e3d72c572dec33ace184195e288d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb003ffd8992a9dcbb11506b23ab4a36f57d48d3bc0f2f29c8d4ac17cf835792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba7b119633bd279b822025aa87b19b1aca9317da8ca69d5db4f72ce2096ca2eb"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
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
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
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