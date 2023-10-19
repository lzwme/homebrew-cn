class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/94/34/59ce21f71603d4c04060c322786fe74dc0ed289977634749a586b631cd7c/svtplay-dl-4.28.1.tar.gz"
  sha256 "f2ab208c4568519e2a1260d3fbaeebaeb590222718e52c222ba42f7cc1bae599"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de86e2e276bca91dab492a5d5624db8960df9724e2b12edb290e98bd424c19c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e65cc6be8a2d63c73487034b28b9de0b63946b2007cbc743da9237eb1beb114"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0faa0907ad7b3901e244e0e6ad93f535ad243f4966b9fff34f078a7b54efa7fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "82c2e0494b387cc44af762f81852302332af4757495b527b1b2eb7035c79a06f"
    sha256 cellar: :any_skip_relocation, ventura:        "a31f2a50e4f3bbd3c5757e5e54422dcf9cd039b2f4a7248908cf3bb37c7e28af"
    sha256 cellar: :any_skip_relocation, monterey:       "61bf5372df4e08c13f21ea9ca24a48b36ba5972848a915351b734209d718e610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b41d6e4fb4ac9ae5d18a209f01806925d115a3bdca2252073cd54ab9e2cb7a5"
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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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