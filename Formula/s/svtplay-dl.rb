class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/52/cc/c56624254fd8321d97094f56284c3ab0de5c2758155c50a0b2552bac33eb/svtplay_dl-4.89.tar.gz"
  sha256 "28c5d7d4c8281d653dfb174b4c4780e4fe7ba120bcb8ce59ef698cafa15e4b5e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "62b8b1f23c5740be262b2fda0988c0ff8e1ba63dbeca2707f18f69dbd6b9fbf3"
    sha256 cellar: :any,                 arm64_ventura:  "38ba44e8e71e2f104ca459228e41eba48eff14dd0da89ba1ba5fbb9f087d8240"
    sha256 cellar: :any,                 arm64_monterey: "01c05bba57b0c4a1a2114902862b6055df28a8cb3c911c1926138ff9ba568944"
    sha256 cellar: :any,                 sonoma:         "363f3c2f17b3cc5d1b1dcb06cf5d7923849f1d7337d9a260c79a1b95b0a4b8ad"
    sha256 cellar: :any,                 ventura:        "4a6c0c8b90e8f24136255eaa7c7d089866efe9d54a292f8356676c8da7cf51b3"
    sha256 cellar: :any,                 monterey:       "b04f4ccbb790169b8c39b57ddaf13f0e56f527b22e5550ae65d2f9a5dfc99aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8638c46764917d27ed16898227a4fc3290787f49fe63503e78f604bcb47d09"
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
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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