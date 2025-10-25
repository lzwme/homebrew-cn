class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/74/28/9d11ae0366a1cb1bf883b47f2267b14d6d012226094d91ed08f91b53d2e1/svtplay_dl-4.151.tar.gz"
  sha256 "85633695e0139a754e87a8c567abbf4338ef4c3599ca872ce6f2beaa8ba88c46"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0393066b088dfccefd88fb6e454fe6538324aef8f0de5bbee814731f98cae995"
    sha256 cellar: :any,                 arm64_sequoia: "1f4a3dd2dc28b13b5274c690d359c9eea363b4c01afba617d4c939d2dc5b263f"
    sha256 cellar: :any,                 arm64_sonoma:  "9e0701a53e06253e5057823dc2e9db27a44a4824a6895df7d60037fc29d5b43b"
    sha256 cellar: :any,                 sonoma:        "73933fc3ac0d18c764d184d3010f1a306d6ed6d2eafa946b296e8eb9a47f78b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eef42fe7068fd498c86b137f28c8e2350296113071a84bc17c1eb64527589a5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f170f8ea59439999699c3bde069e79ab522dd92f9b91547f8b2429225b5429"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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