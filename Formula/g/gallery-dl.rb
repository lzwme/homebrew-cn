class GalleryDl < Formula
  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/79/73/87d61facef7cc7e461ac7a3ca07dce0d8577f79032d3b7c783c18d612cb8/gallery_dl-1.26.2.tar.gz"
  sha256 "02071cb33d139730839e1479572ed3b778ebab3f7e87069c95081724184663dc"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70735a735b4723ec140fcbd12624f67a7e824e021a76caa7c14d58dbb35669f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf2151a84115297649ca27dcab202c74040b15699e1269d0e04b908b51032124"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ac793c5f25a42dcb7f2855c0d8c0cfee5fa64aabad0566eca0eff21a243b1a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d33b63e3bf85609597144c1a9516aaaa2c1e4951e7b0967aeba0ff1ae96ee51"
    sha256 cellar: :any_skip_relocation, ventura:        "b01c4842be612bfb66877abca08c30275ce65f06c407907ae099a45d375ea9ff"
    sha256 cellar: :any_skip_relocation, monterey:       "6f3739cfb0048e382b465b2b0d489ea8f9482f2af72fc45f145d50a211047ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ce477112e762bbef22deeb496922e4d3bf19177e1d7601ff9cef4823e7101e3"
  end

  depends_on "python-setuptools" => :build
  depends_on "python-requests"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end