class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/be/05/db6932f3f27b24fd33dcc924584bbe8401211120763a8dc0733eaa8bc6a2/gallery_dl-1.25.3.tar.gz"
  sha256 "6a8b1a03c17c4d5067634333f936d16108d55b91540e24a2a2197feefa97c22b"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c01e31a99da7a3c9d7d6abe6467599b80e80ff8ef8cf6a50704d839ed79f9fec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aff24fbec9499e41bc3f17fdda48ce81337ab84e78ada1be3226873408a61f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9050dc83ebd57ba74f95845ccb0b0b94a76dbf895147781359111a12681f8377"
    sha256 cellar: :any_skip_relocation, ventura:        "0baa973f6206c633b6feae4483ec31de61362ef5625d6589e0872bf6bb65db41"
    sha256 cellar: :any_skip_relocation, monterey:       "9606db5633eed3a7052686a79d7eafbd72ae2d782d526451f847a9ad7546caa2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ae54b784c51d3a67225035ee9fa951b63cbfa55a9c65f46d1645e83091e1cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944435d1e7fdf47dc1f5a6e4afd7580e193e1c55463a9c9b6745b0231cf4a922"
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
    url "https://files.pythonhosted.org/packages/4c/d2/70fc708727b62d55bc24e43cc85f073039023212d482553d853c44e57bdb/requests-2.29.0.tar.gz"
    sha256 "f2e34a75f4749019bb0e3effb66683630e4ffeaf75819fb51bebef1bf5aef059"
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