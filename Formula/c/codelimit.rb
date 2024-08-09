class Codelimit < Formula
  include Language::Python::Virtualenv

  desc "Your Refactoring Alarm"
  homepage "https:github.comgetcodelimitcodelimit"
  url "https:files.pythonhosted.orgpackages7f0c6b864f6263d0ce25df2b06960c1109143a32431c74b6205e693eee6ad296codelimit-0.9.4.tar.gz"
  sha256 "6bf1b76d2e12f0cc5de85e69f33aee006664c4f546391e4c44e55a7df8daef61"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "514ff56996c45d255e005d6875991645bd54358de3a4e27e6af84fd618f4442b"
    sha256 cellar: :any,                 arm64_ventura:  "04a8d6d52aa6a2bd71a9734a4046745c18211ca7d03477418c4e76dbe9d643c0"
    sha256 cellar: :any,                 arm64_monterey: "2762986c93f53881351265f6812aed84416a2285c3faae4d01590f0253b76f06"
    sha256 cellar: :any,                 sonoma:         "07c6fead62ac2133be8d368ab5b9e0700da60c8ec8ce155c79aeba333e71673e"
    sha256 cellar: :any,                 ventura:        "bda4c411573d9750d766f7f9fada792db377ab7b64657606ef29e95a489dc287"
    sha256 cellar: :any,                 monterey:       "1a7521374303339ad407f18390c10475d9ed65ebf89be19af4222d75497dbd28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca03332b48b54e2d60404c44245489aef0289da489a5de600b0762003d0f3f58"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackagesb7c3112f2f992aeb321de483754c1c5acab08c8ac3388c9c7e6f3e4f45ec1c42aiohappyeyeballs-2.3.5.tar.gz"
    sha256 "6fa48b9f1317254f122a07a131a86b71ca6946ca989ce6326fff54a99a920105"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesf7e1bfcafd54dee859b2e6e690c5f8a8a30343d590a8822bb0669afba4c2c9e6aiohttp-3.10.1.tar.gz"
    sha256 "8b0d058e4e425d3b45e8ec70d49b402f4d6b21041e674798b1f91ba027c73f28"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackagese97db1e0399aa5e27071f0042784681d28417f3e526c61f62c8e3635ee5ad334typer-0.9.4.tar.gz"
    sha256 "f714c2d90afae3a7929fcd72a3abb08df305e1ff61719381384211c4070af57f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.py").write <<~EOS
      def foo():
        print('Hello world!')
    EOS

    assert_includes shell_output("#{bin}codelimit check #{testpath}test.py"), "Refactoring not necessary"
  end
end