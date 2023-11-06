class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/79/73/87d61facef7cc7e461ac7a3ca07dce0d8577f79032d3b7c783c18d612cb8/gallery_dl-1.26.2.tar.gz"
  sha256 "02071cb33d139730839e1479572ed3b778ebab3f7e87069c95081724184663dc"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c69d4d1b2c48daedc8e7e1a69d9b5a3a083b37b3c9217dfc81b920fe4703195"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3209431e2aaa13cd6d0837c1b509fab9cbcc8e33bd71a7976dc959dbc59f2307"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "633faea77590fc0cc58badf213655f61886a8d7579172fc282f5e54b8962bf5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a80339bba852d9a685e4cd87f845c310e3cf65751cebf99e81c6840d0b3dcc59"
    sha256 cellar: :any_skip_relocation, ventura:        "f801e755101b789632f58106e5675c1a309fcde42426fcac3fc5fde624f2f8aa"
    sha256 cellar: :any_skip_relocation, monterey:       "eb493f1c831229301f7777d8479b3cf531eb8fda64a6c5d97623ffafb43c7edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42afa425f85f957f78cbd9d4d4d831583032c6a0ff64e36173ef70fcbf15bea3"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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