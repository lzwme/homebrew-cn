class Animdl < Formula
  include Language::Python::Virtualenv

  desc "Anime downloader and streamer"
  homepage "https://github.com/justfoolingaround/animdl"
  url "https://files.pythonhosted.org/packages/95/f2/27b66201f95d9d5cb1ac5d012d42aa09ef68cca965f039ff4e82f7ea2b3b/animdl-1.7.24.tar.gz"
  sha256 "be531bbeafa0ee48a74405f6356691d2a1073ebd6c1d4169142a6948723450ba"
  license "GPL-3.0-only"
  head "https://github.com/justfoolingaround/animdl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfddb9d0c6a99a9698955b27d69f23e52ab7b0b4598d72d33f5a2f52bfad0c81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469f0730ff5a0aea2b9e63d5c94f8aad7f738173c9ce0aea9450a499800a3478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "818dca6cd99b1b67ba1f48a36ae41db139d4e92f01614963545f8518a27f4bcd"
    sha256 cellar: :any_skip_relocation, ventura:        "5a25312bcf45f40974fa7b7469a95fcf27e89ee91bee4514c8ec748e0f604e21"
    sha256 cellar: :any_skip_relocation, monterey:       "b95f5252df652707aa354f5e5ea88a970028be83e07706987a521204986ce000"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd6e0b9b119bb4f9d052da4812748c926dcc9f63538eaa5396094fd10187ee9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90ff5576f17d118249f409b09358f21520d6a23b3cc0345117e337aa1f1fa98a"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "anchor-kr" do
    url "https://files.pythonhosted.org/packages/dd/46/c96feb94c9101ca57b9d612b6510b06da31d31321e5c54fca6cb4a6a0adf/anchor-kr-0.1.3.tar.gz"
    sha256 "0fc055b6fd359bd20225dc4c39f721535af3245b068724db09c62a0f95ec4bbf"
  end

  resource "anitopy" do
    url "https://files.pythonhosted.org/packages/d3/8b/3da3f8ba73b8e4e5325a9ecbd6780f4dc9f41c98cc1c6a897800c4f85979/anitopy-2.1.1.tar.gz"
    sha256 "515b97cd78917ee406313f4eb53bdc75e8a573e6ad5252ffd355c96a06988e26"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/74/17/5075225ee1abbb93cd7fc30a2d343c6a3f5f71cf388f14768a7a38256581/anyio-4.0.0.tar.gz"
    sha256 "f7ed51751b2c2add651e5747c891b47e26d2a21be5d32d9311dfe9692f3e5d7a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "comtypes" do
    url "https://files.pythonhosted.org/packages/e9/c3/f1b3d86f210e42c3103d4e6c22b9775747d78c337acd3f7f7ab615f5c3e2/comtypes-1.1.14.zip"
    sha256 "5d7caf6d3a86d51ddfc53e4548cae2dceee1b46672f8bd59679711dd01a934f2"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/61/42/5c456b02816845d163fab0f32936b6a5b649f3f915beff6f819f4f6c90b2/httpcore-0.16.3.tar.gz"
    sha256 "c5d6f04e2fc530f39e0c077e6a30caa53f1451096120f1f38b954afd0b17c0cb"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/f5/50/04d5e8ee398a10c767a341a25f59ff8711ae3adf0143c7f8b45fc560d72d/httpx-0.23.3.tar.gz"
    sha256 "9818458eb565bb54898ccb9b8b251a28785dd4a55afbc23d0eb410754fe7d0f9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/b4/1c/89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129/pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/24/40/e249ac3845a2333ce50f1bb02299ffb766babdfe80ca9d31e0158ad06afd/pycryptodomex-3.14.1.tar.gz"
    sha256 "2ce76ed0081fd6ac8c74edc75b9d14eca2064173af79843c24fa62573263c1f2"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/9a/50/672a8d347f92bc752b04c338bbf932fbd0104fbc416c82cc91aa5f7b4b0b/rich-13.3.3.tar.gz"
    sha256 "dc84400a9d842b3a9c5ff74addd8eb798d155f36c1c91303888e0a66850d2a15"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/06/04/e65e7f457ce9a2e338366a3a873ec6994e081cf4f99becb59ab6ce19e4b5/tqdm-4.65.2.tar.gz"
    sha256 "5f7d8b4ac76016ce9d51a7f0ea30d30984888d97c474fdc4a4148abfb5ee76aa"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/c4/1e/1b204050c601d5cd82b45d5c8f439cb6f744a2ce0c0a6f83be0ddf0dc7b2/yarl-1.8.2.tar.gz"
    sha256 "49d43402c6e3013ad0978602bf6bf5328535c48d192304b91b97a3c6790b1562"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"config.yml"
    test_config.write <<~EOS
      default_provider: animixplay
    EOS

    assert_match "One Piece Film", shell_output("#{bin}/animdl search \"one piece\" 2>&1")
    assert_match "animdl, version #{version}", shell_output("#{bin}/animdl --version")
  end
end