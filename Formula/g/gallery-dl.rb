class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/31/3c/606a043bff19bc726bf98d0bfdae7006f3dcc1797666b2fc6e33470fe432/gallery_dl-1.26.1.tar.gz"
  sha256 "489b2111dbe63c3419e66aa241f26959c438dd61975313ef30c26263fe02c6c7"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69ab99f65de839623f0615ab874dbf27d128a8ace0e6f251b53dfab92179288f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "345d691759ed17efc9aa460273b6e274a03bfe0e8edab03980d40bd4a6ff4f36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "191f6e1d47827c1e6ce9c020c3928576f847f1073ceaf764f9aa1481a83dd5c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a30f572d59291efdc3d81b5328ce8f7bcb3f10d8a372841db27fd4e552b1fe4"
    sha256 cellar: :any_skip_relocation, ventura:        "c022c6c8493d75f4283c29808062144ef15aa3444bdc06c16f0d94d22ae69b5e"
    sha256 cellar: :any_skip_relocation, monterey:       "13e4301b6fd7330489d6bf79ea98d7a78c10ec06892202252fb02bd4e818c211"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74d73d011866e9c444fa135654d983f50f7533346f72eacad0939fa2d4f602be"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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