class Animdl < Formula
  include Language::Python::Virtualenv

  desc "Anime downloader and streamer"
  homepage "https:github.comjustfoolingaroundanimdl"
  url "https:files.pythonhosted.orgpackages5b794be6ac2caca32dea6fe500e5f5df9d74a3a5ce1d500175c3a7b69500bb3fanimdl-1.7.27.tar.gz"
  sha256 "fd97b278da4c82da88759993eaf6d8ad6fc3660d0f03de5b2151279c4ebd8370"
  license "GPL-3.0-only"
  head "https:github.comjustfoolingaroundanimdl.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "2e87b8f2b10b5a5f0c2b30e942469c9ec6502188ae51e4907ab410e322d751da"
    sha256 cellar: :any,                 arm64_ventura:  "571df10ef8ef2369b216a10d579f8af335ac406c12299fbf236ed0d666cadb6d"
    sha256 cellar: :any,                 arm64_monterey: "45330a730e07da5f3829c97969fde758440ab5a06c4daa827ba850c24de5f193"
    sha256 cellar: :any,                 sonoma:         "e426858eb003958f32050b0cf53707251f00d5434356bc4d2e627650db25c705"
    sha256 cellar: :any,                 ventura:        "6461e1336071053621bd6bf25e0104aa7f6d00317e395ec73d0526662959e9ef"
    sha256 cellar: :any,                 monterey:       "d75d262a81d0c9e32cca590357a015aa591525b683ad3145d926bcc3e7ad62d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abbba04510c785c5cd6b6881c809ca82f3126c101e76b2b95c69d149d720014f"
  end

  depends_on "libyaml"
  depends_on "python-certifi"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "anchor-kr" do
    url "https:files.pythonhosted.orgpackagesdd46c96feb94c9101ca57b9d612b6510b06da31d31321e5c54fca6cb4a6a0adfanchor-kr-0.1.3.tar.gz"
    sha256 "0fc055b6fd359bd20225dc4c39f721535af3245b068724db09c62a0f95ec4bbf"
  end

  resource "anitopy" do
    url "https:files.pythonhosted.orgpackagesd38b3da3f8ba73b8e4e5325a9ecbd6780f4dc9f41c98cc1c6a897800c4f85979anitopy-2.1.1.tar.gz"
    sha256 "515b97cd78917ee406313f4eb53bdc75e8a573e6ad5252ffd355c96a06988e26"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesdb4d3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "comtypes" do
    url "https:files.pythonhosted.orgpackagese9c3f1b3d86f210e42c3103d4e6c22b9775747d78c337acd3f7f7ab615f5c3e2comtypes-1.1.14.zip"
    sha256 "5d7caf6d3a86d51ddfc53e4548cae2dceee1b46672f8bd59679711dd01a934f2"
  end

  resource "cssselect" do
    url "https:files.pythonhosted.orgpackagesd191d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081ccssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages61425c456b02816845d163fab0f32936b6a5b649f3f915beff6f819f4f6c90b2httpcore-0.16.3.tar.gz"
    sha256 "c5d6f04e2fc530f39e0c077e6a30caa53f1451096120f1f38b954afd0b17c0cb"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesf55004d5e8ee398a10c767a341a25f59ff8711ae3adf0143c7f8b45fc560d72dhttpx-0.23.3.tar.gz"
    sha256 "9818458eb565bb54898ccb9b8b251a28785dd4a55afbc23d0eb410754fe7d0f9"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages2bb4bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackagese4c059bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pkginfo" do
    url "https:files.pythonhosted.orgpackagesb41c89b38e431c20d6b2389ed8b3926c2ab72f58944733ba029354c6d9f69129pkginfo-1.9.6.tar.gz"
    sha256 "8fd5896e8718a4372f0ea9cc9d96f6417c9b986e23a4d116dda26b62cc29d046"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackages2440e249ac3845a2333ce50f1bb02299ffb766babdfe80ca9d31e0158ad06afdpycryptodomex-3.14.1.tar.gz"
    sha256 "2ce76ed0081fd6ac8c74edc75b9d14eca2064173af79843c24fa62573263c1f2"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages27b592d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "rfc3986" do
    url "https:files.pythonhosted.orgpackages79305b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackages9a50672a8d347f92bc752b04c338bbf932fbd0104fbc416c82cc91aa5f7b4b0brich-13.3.3.tar.gz"
    sha256 "dc84400a9d842b3a9c5ff74addd8eb798d155f36c1c91303888e0a66850d2a15"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagescd50d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0acsniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages0604e65e7f457ce9a2e338366a3a873ec6994e081cf4f99becb59ab6ce19e4b5tqdm-4.65.2.tar.gz"
    sha256 "5f7d8b4ac76016ce9d51a7f0ea30d30984888d97c474fdc4a4148abfb5ee76aa"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  # Multiple resources are too old to build on recent XcodemacOS,
  # can delete this after a change like this is merged and released in a new version:
  # https:github.comjustfoolingaroundanimdlpull301
  # The patch isn't strictly needed but it's an easy way to see which Python `resource`
  # blocks needed to be manually bumped to newer versions.
  patch :DATA

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"animdl", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    test_config = testpath"config.yml"
    test_config.write <<~EOS
      default_provider: animixplay
    EOS

    assert_match "One Piece Film", shell_output("#{bin}animdl search \"one piece\" 2>&1")
    assert_match "animdl, version #{version}", shell_output("#{bin}animdl --version")
  end
end
__END__
diff --git apyproject.toml bpyproject.toml
index e0e8782..e71eacf 100644
--- apyproject.toml
+++ bpyproject.toml
@@ -21,8 +21,8 @@ httpx = "~=0.23.0"
 tqdm = ">=4.62.3,<4.66.0"
 pycryptodomex = "~=3.14.1"
 regex = "~=2022.10.31"
-yarl = "~=1.8.1"
-pyyaml = "~=6.0"
+yarl = "~=1.9.4"
+pyyaml = "~=6.0.1"
 packaging = ">=22,<24"
 pkginfo = "^1.9.2"
 rich = ">=13.3.1,<13.3.4"
@@ -33,5 +33,5 @@ rich = ">=13.3.1,<13.3.4"
 animdl = "animdl.__main__:__animdl_cli__"
 
 [tool.poetry.dependencies.lxml]
-version = "4.9.1"
+version = "5.1.0"
 markers = "sys_platform != 'win32'"