class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/a8/73/93eb9fb5e296700470108495ec128708b8e15a09f3cd32145a3b7b6f4a12/gallery_dl-1.26.0.tar.gz"
  sha256 "fa0e2d7ebed117daeb8a641c5e1733de8fc2c7dc4b36b4c3575171ed74b187b2"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e947e67471f683cd4802d75afe0c01512508d57662ed6c0ed48937b45c5e7b64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e9c415d80cd78d0eed4156ee5e84c2aac2256f8b9ad3cf86aa2dcc992a85d3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdbd6b955ccd13c96bbab4ac391eb51cddc8af574caa2e58dabb0acc907898d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "608cb397d02bf1cb7810d89648c0ce72cfe018f7c3ee22ab93f3fd3119e56f23"
    sha256 cellar: :any_skip_relocation, ventura:        "098e8c09347b97d212efc380bce4ce870600544f0c9930149c2c17acb324e696"
    sha256 cellar: :any_skip_relocation, monterey:       "72ebe2a70b5bddda0faa31940ae5fe97e7ff465e8e6d2774c7bcbc40dd6168b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24fd18910973c1d8a79a6d624b88542e4d652598936f7aeb89dc2ed18d414f39"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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