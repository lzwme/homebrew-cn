class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https:scrapy.org"
  url "https:files.pythonhosted.orgpackages8adb6acda5c8c407dbb1a210a7a9732f86ed7eacb22bd500b589a13716e634cbscrapy-2.13.0.tar.gz"
  sha256 "9661629805ff0e43054cc1306d9b13236c6bb9565d8d8e303a332c8da045d90f"
  license "BSD-3-Clause"
  head "https:github.comscrapyscrapy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25defebb119a5871425b507cb20c177de0a71a10b5fe71f1aab2586eb926c880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb183278491aa21d398ed826047c7e017b114f071aca33b85ac4121cdddd6c56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "132bef755d1cecd7337bdfc08768cb5ef47f0b8d71709a3e1faff98c9b9bcb8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "526526f3d4432db8f598c0c28d7ef90457d7bf76e60a65742a4d09dd7ba88f3c"
    sha256 cellar: :any_skip_relocation, ventura:       "71f308ec9fc68eb4edd8f2a5d12a3a9c8865befce7f99ec3ef7f3d0afdfaa359"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb7c6c7f2b42c5007376ee87ee08f6e02c6f8a673d597ee6565b64acf7c38e35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4acb935a8569e94f71e6cc3e6079e45001c4e7154742c7f3b2d27b03b1def370"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "automat" do
    url "https:files.pythonhosted.orgpackagese30fd40bbe294bbf004d436a8bcbcfaadca8b5140d39ad0ad3d73d1a8ba15f14automat-25.4.16.tar.gz"
    sha256 "0017591a5477066e90d26b0e696ddc143baafd87b588cfac8100bc6be9634de0"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "constantly" do
    url "https:files.pythonhosted.orgpackages4d6fcb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324dconstantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "cssselect" do
    url "https:files.pythonhosted.orgpackages720ac3ea9573b1dc2e151abfe88c7fe0c26d1892fe6ed02d0cdb30f0d57029d5cssselect-1.3.0.tar.gz"
    sha256 "57f8a99424cfab289a1b6a816a43075a4b00948c86b4dcf3ef4ee7e15f7ab0c7"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages0a10c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9afilelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "hyperlink" do
    url "https:files.pythonhosted.orgpackages3a511947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412ehyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "incremental" do
    url "https:files.pythonhosted.orgpackages2787156b374ff6578062965afe30cc57627d35234369b3336cf244b240c8d8e6incremental-24.7.2.tar.gz"
    sha256 "fb4f1d47ee60efe87d4f6f0ebb5f70b9760db2b2574c59c8e8912be4ebd464c9"
  end

  resource "itemadapter" do
    url "https:files.pythonhosted.orgpackages3d4a3fac3054be284c160b142460d7337c56e89d7be094c7895b113b2b01c256itemadapter-0.11.0.tar.gz"
    sha256 "3b0f27f4c5e2e8ae415d83e3d60d33adb7ba09b98c30638bc606fb1dff2ecdd2"
  end

  resource "itemloaders" do
    url "https:files.pythonhosted.orgpackagesb63ec549370e95c9dc7ec5e155c075e2700fa75abe5625608a4ce5009eabe0bfitemloaders-1.3.2.tar.gz"
    sha256 "4faf5b3abe83bf014476e3fd9ccf66867282971d9f1d4e96d9a61b60c3786770"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages763d14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08flxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "parsel" do
    url "https:files.pythonhosted.orgpackagesf6dfacd504c154c0b9028b0d8491a77fdd5f86e9c06ee04f986abf85e36d9a5fparsel-1.10.0.tar.gz"
    sha256 "14f17db9559f51b43357b9dfe43cec870a8efb5ea4857abb624ec6ff80d8a080"
  end

  resource "protego" do
    url "https:files.pythonhosted.orgpackages4e6b84e878d0567dfc11538bad6ce2595cee7ae0c47cf6bf7293683c9ec78ef8protego-0.4.0.tar.gz"
    sha256 "93a5e662b61399a0e1f208a324f2c6ea95b23ee39e6cbf2c96246da4a656c2f6"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagese9e678ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydispatcher" do
    url "https:files.pythonhosted.orgpackages21db030d0700ae90d2f9d52c2f3c1f864881e19cef8cba3b0a08759c8494c19cPyDispatcher-2.0.7.tar.gz"
    sha256 "b777c6ad080dc1bad74a4c29d6a46914fa6701ac70f94b0d66fbcfde62f5be31"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages9f26e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  resource "queuelib" do
    url "https:files.pythonhosted.orgpackages4c789ace6888cf6d390c9aec3ba93020838b08934959b544a7f10b15db815d29queuelib-1.8.0.tar.gz"
    sha256 "582bc65514481100b0539bd671da6b355b878869cfc77d92c63b75fcc9cf8e27"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages7297bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1aerequests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "service-identity" do
    url "https:files.pythonhosted.orgpackages07a5dfc752b979067947261dbbf2543470c58efe735c3c1301dd870ef27830eeservice_identity-24.2.0.tar.gz"
    sha256 "b8683ba13f0d39c6cd5d625d2c5f65421d6d707b013b375c355751557cbe8e09"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages70dc3976b322de9d2e87ed0007cf04cc7553969b6c7b3f48a565d0333748fbcdsetuptools-80.3.1.tar.gz"
    sha256 "31e2c58dbb67c99c289f51c16d899afedae292b978f8051efaf6262d8212f927"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackages9778182641ea38e3cfd56e9c7b3c0d48a53d432eea755003aa544af96403d4actldextract-5.3.0.tar.gz"
    sha256 "b3d2b70a1594a0ecfa6967d57251527d58e00bb5a91a74387baa0d87a0678609"
  end

  resource "twisted" do
    url "https:files.pythonhosted.orgpackages771ce07af0df31229250ab58a943077e4adbd5e227d9f2ac826920416b3e5fa2twisted-24.11.0.tar.gz"
    sha256 "695d0556d5ec579dcc464d2856b634880ed1319f45b10d19043f2b57eb0115b5"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "w3lib" do
    url "https:files.pythonhosted.orgpackagesbf7d1172cfaa1e29beb9bf938e484c122b3bdc82e8e37b17a4f753ba6d6e009fw3lib-2.3.1.tar.gz"
    sha256 "5c8ac02a3027576174c2b61eb9a2170ba1b197cae767080771b6f1febda249a4"
  end

  resource "zope-interface" do
    url "https:files.pythonhosted.orgpackages30939210e7606be57a2dfc6277ac97dcc864fd8d39f142ca194fdc186d596fdazope.interface-7.2.tar.gz"
    sha256 "8b49f1a3d1ee4cdaf5b32d2e738362c7f5e40ac8b46dd7d1a65e82a4872728fe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}scrapy version")

    system bin"scrapy", "startproject", "brewproject"
    cd testpath"brewproject" do
      system bin"scrapy", "genspider", "-t", "basic", "brewspider", "brew.sh"
      assert_match "INFO: Spider closed (finished)", shell_output("#{bin}scrapy crawl brewspider 2>&1")
    end
  end
end