class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/de/d0/643f602c7036a5b840f665d16488021a14caebc1a82bec3a5b2faca4c9b2/svtplay-dl-4.79.tar.gz"
  sha256 "2b8543445e056af5f1789e1a498aa3c11a9ffaa5a8d52556691c47f16fda84bb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f52f11c2b0313c1e48e7b1fa75c66d0ece4e49c6977dc9e83113598f7fcc633e"
    sha256 cellar: :any,                 arm64_ventura:  "e88fef731f867ddea2275f7597b0e3e143b52f1008daabc1edc33403636a73b2"
    sha256 cellar: :any,                 arm64_monterey: "f46247dba89a1f36ef8af9ad41c51ed361501275b9b53e647401e6f3c8979009"
    sha256 cellar: :any,                 sonoma:         "8fde63af3b85e31a90c536ed7043a9e7dbf2c01dbf0d8f9edf19c7d59a96dd41"
    sha256 cellar: :any,                 ventura:        "ab799fc1b106af35df36bb5f541a9f726407f7e2a9fdf77b2131afad33dbee39"
    sha256 cellar: :any,                 monterey:       "3f2f495c7d58cbe533cda565f68cb9186edd9bdb38a7721b9a2035d03c1e065d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcb74bbbeb692830108fb8a06e75b89afbf60e054e6bc57685f23b1584b139cf"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use post-processing options:
        `brew install ffmpeg` or `brew install libav`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/video/357803"
    match = "https://amd-ab.akamaized.net/ab/vod/2023/07/64b249d222f325d618162f76/720_3500_pkg.m3u8"
    assert_match match, shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end