class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/91/8a/1a9f190ffc9d68a97b5d9392aa7440b79f5d7769cc5bc2df4c325eb44596/svtplay-dl-4.27.tar.gz"
  sha256 "160b9871ce227b2c012c222c69e558d9b4a8f4bbd1feaa61ff6af3dac5ead0f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c103f046cd5fba4aedfe984278ce7233b161aa1552b31d8bec57c080b7cd513"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d329b8d169f6a01ab256f1eda712f0cd85ea73de50a5be1854ff1d3dee41455"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a92202dde274138be4a3164595e4ee5ff35d4ae5f4deec6b888d36f5cf115a91"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ffc8a7ee9479aff7174150d6dbba8cffc2bf1d8d9649daafc420a17ccead2d5"
    sha256 cellar: :any_skip_relocation, ventura:        "c5da176db39ff6a27a8f60f7946b0ad59483cce518a9d6fa9a87af551be076e3"
    sha256 cellar: :any_skip_relocation, monterey:       "3f5f938097a463eac305cff5806a68509d92aaa6f6cb5a67bf439512858d9ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ee4ffaa372472b0c7a46aa7c1ae00da26e6e97dfb43f8fbc637964de1766666"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
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