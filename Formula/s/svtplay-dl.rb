class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/94/34/59ce21f71603d4c04060c322786fe74dc0ed289977634749a586b631cd7c/svtplay-dl-4.28.1.tar.gz"
  sha256 "f2ab208c4568519e2a1260d3fbaeebaeb590222718e52c222ba42f7cc1bae599"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a197cab5e1e821db1014e25de5410c0cf26db587545507b3d42dcb25311ee70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b21ec0a26f99c7915c6d8dda9228e03d369e4a2cc8734bb8a189e7067dd58e1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1306a44b56392036db34860a5a8cc709b94bff2e514c9c6246f541a313c3170"
    sha256 cellar: :any_skip_relocation, sonoma:         "60cd0da0da181f60dc0f9bdcb7e292f7499999b733b56d9db1c19ad8c0c90d5e"
    sha256 cellar: :any_skip_relocation, ventura:        "e7ae851a17a2b9e691429d4cff17aa2acc9597cd8a4fb2c0d22bc86546584788"
    sha256 cellar: :any_skip_relocation, monterey:       "5de8bbc7529078e3c3b766317cd6760f6e1a2ae1e906ae9a199ec947aded9436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "968980f91f4bf8abec6068e22fb60c72a38be68c6d00a93616192e91f72b61bd"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"
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