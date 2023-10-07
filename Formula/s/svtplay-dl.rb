class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/6d/67/11d664a155856ca12c3db4782288ea44c2ccb18793a8a58ab4b855bd267e/svtplay-dl-4.25.tar.gz"
  sha256 "c6d0166ff059ee18017241bee5d7343be52cfc6e12939513ae26fdf5ad55508e"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "823ca2830b88371d12f01dcb9376de4283be384b38e8845113632b3ef1baabd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d2ceb49d1d2240fb105b026899abe18728c285c2a201f65a4dfa11a341133d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e36cc3eda2e7576cd1459066d5bb32e58bbe9b9840d63ef59d705ba52ae59c53"
    sha256 cellar: :any_skip_relocation, sonoma:         "70aa6b965b894aba966298c7fdb027049570e6b21496f68f551c88236698d679"
    sha256 cellar: :any_skip_relocation, ventura:        "495acc324c8b45347b51800ce8a251489e809655ca4747fd8eadbc657d1e56a0"
    sha256 cellar: :any_skip_relocation, monterey:       "a05c39ae318b600fd4b0401b4b8376a89894c486d57f78ecf39b491a72733b3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7a673a55aaaeeb2a28e50b3e7a5e155656b4ea175bbab479a4f3fea6932b8da"
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