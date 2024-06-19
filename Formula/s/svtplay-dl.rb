class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/e9/0c/570d6d9277a2ad144a1d548f0c47c352df3fdb233bec5f5276b249158917/svtplay_dl-4.83.tar.gz"
  sha256 "61cc7475bbca530c90ecf057fbb22bade3dd4d68b7c1636bf6571faf36eab0df"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9559d62dc3a3d9c6ae375defb425b54ca45e84c3a09ea6d31825535cf5092d21"
    sha256 cellar: :any,                 arm64_ventura:  "b3ec820f1165524b26dc3f0d687d9ec0dc798a4532d30ca9aa0c54cbcdc30e49"
    sha256 cellar: :any,                 arm64_monterey: "3517d54db829b73cd31532eff7cce958506d75c1633bba56c59c3425453a8e09"
    sha256 cellar: :any,                 sonoma:         "5ea36cd44c6a7445ff30fcbe06913f45c16429f15f3dd863a41b35521a2f521a"
    sha256 cellar: :any,                 ventura:        "2e0aa37c6f6fc1f17ec5f7e6842c4e2ff1984e08bf7a5ed0bc3d80f58bf6def8"
    sha256 cellar: :any,                 monterey:       "7099b0b4d5a23fafc7d301507a5d6f175dedf078d6c68fe0918fe451142fbcac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1e240cfdb15624c6b5c04aaa32f5c9c9a904b16e4693531ffbeca9e9e81098e"
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