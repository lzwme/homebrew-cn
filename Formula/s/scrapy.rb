class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https:scrapy.org"
  url "https:files.pythonhosted.orgpackagesf21f5524416a64c030fbe18caeba079e7176836b281bf9eb50b79efdf8015063scrapy-2.11.2.tar.gz"
  sha256 "dfbd565384fc3fffeba121f5a3a2d0899ac1f756d41432ca0879933fbfb3401d"
  license "BSD-3-Clause"
  head "https:github.comscrapyscrapy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84db6bc459afaaa8608b14dd81253cf0ac0f2cc94ed31e642cb0f5fb4620909e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab51a129e69cec80e9bc7b8b07c1dc58db74a9a6e883e3212e5d66ff8d589229"
    sha256 cellar: :any,                 arm64_monterey: "d3c452bdf51734aa439a4c12fbd6c47d349c5eefa6d131872de6aacd394c6184"
    sha256 cellar: :any_skip_relocation, sonoma:         "45bcf9184737a6f60ffb4cb57783a8986f196ad61c83bbdce651274996435e96"
    sha256 cellar: :any_skip_relocation, ventura:        "5d66920d0d239699044b367df6cb1dca9a447ba97aeaebf52445c8196301d680"
    sha256 cellar: :any,                 monterey:       "0fb25a58bfae16e4caaf97faa1d388d2e9002615975bae90d23289303464003d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a50a57ad423abaffbb25c176dadbb9defd085ce67d44e96119b6597ae5b250ed"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "automat" do
    url "https:files.pythonhosted.orgpackages7a7b9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4Automat-22.10.0.tar.gz"
    sha256 "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "constantly" do
    url "https:files.pythonhosted.orgpackages4d6fcb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324dconstantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "cssselect" do
    url "https:files.pythonhosted.orgpackagesd191d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081ccssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages06aef8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897eafilelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "hyperlink" do
    url "https:files.pythonhosted.orgpackages3a511947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412ehyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "incremental" do
    url "https:files.pythonhosted.orgpackages86429e87f04fa2cd40e3016f27a4b4572290e95899c6dce317e2cdb580f3ff09incremental-22.10.0.tar.gz"
    sha256 "912feeb5e0f7e0188e6f42241d2f450002e11bbc0937c65865045854c24c0bd0"
  end

  resource "itemadapter" do
    url "https:files.pythonhosted.orgpackageseb60a16c93c9d26e83c05bc6b3edc1a8013025b37ca82dee7eda6f89aec583d3itemadapter-0.9.0.tar.gz"
    sha256 "e4f958a6b6b6f5831fa207373010031a0bd7ed0429ddd09b51979c011475cafd"
  end

  resource "itemloaders" do
    url "https:files.pythonhosted.orgpackagese565e43fb029445a332ed6620ee93be29a94c023a16a0e59f17a5f3665987e79itemloaders-1.2.0.tar.gz"
    sha256 "fc2307f984116b010d6101a68a6a133ac8de927320b0ab696f31ad710a8d8d98"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages63f7ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055blxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "parsel" do
    url "https:files.pythonhosted.orgpackages87bdb982085f091367ca25ccb61f2d127655a0daac1716ecfde014ab7c538116parsel-1.9.1.tar.gz"
    sha256 "14e00dc07731c9030db620c195fcae884b5b4848e9f9c523c6119f708ccfa9ac"
  end

  resource "protego" do
    url "https:files.pythonhosted.orgpackages8a12cab9fa77ff4e9e444a5eb5480db4b4f872c03aa079145804aa054be377bcProtego-0.3.1.tar.gz"
    sha256 "e94430d0d25cbbf239bc849d86c5e544fbde531fcccfa059953c7da344a1712c"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagesf700e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pydispatcher" do
    url "https:files.pythonhosted.orgpackages21db030d0700ae90d2f9d52c2f3c1f864881e19cef8cba3b0a08759c8494c19cPyDispatcher-2.0.7.tar.gz"
    sha256 "b777c6ad080dc1bad74a4c29d6a46914fa6701ac70f94b0d66fbcfde62f5be31"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages91a8cbeec652549e30103b9e6147ad433405fdd18807ac2d54e6dbb73184d8a1pyOpenSSL-24.1.0.tar.gz"
    sha256 "cabed4bfaa5df9f1a16c0ef64a0cb65318b5cd077a7eda7d6970131ca2f41a6f"
  end

  resource "queuelib" do
    url "https:files.pythonhosted.orgpackagesfba48af5d8ee3526c64a152549a1c7b42896be9fae9a2fda7712883dc09822acqueuelib-1.7.0.tar.gz"
    sha256 "2855162096cf0230510890b354379ea1c0ff19d105d3147d349d2433bb222b08"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages2b69ba1b5f52f96cde4f2d8eca74a0aa2c11a66b2fe58d0fb63b2e46edce6ed3requests-file-2.0.0.tar.gz"
    sha256 "20c5931629c558fda566cacc10cfe2cd502433e628f568c34c80d96a0cc95972"
  end

  resource "service-identity" do
    url "https:files.pythonhosted.orgpackages38d22ac20fd05f1b6fce31986536da4caeac51ed2e1bb25d4a7d73ca4eccdfabservice_identity-24.1.0.tar.gz"
    sha256 "6829c9d62fb832c2e1c435629b0a8c476e1929881f28bee4d20bc24161009221"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesd64fb10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aedsetuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackagesdbedc92a5d6edaafec52f388c2d2946b4664294299cebf52bb1ef9cbc44ae739tldextract-5.1.2.tar.gz"
    sha256 "c9e17f756f05afb5abac04fe8f766e7e70f9fe387adb1859f0f52408ee060200"
  end

  resource "twisted" do
    url "https:files.pythonhosted.orgpackagesfc8d9c09d75173984d3b0f0dcf65d885fe61a06de11db2c30b1196d85f631cfctwisted-24.3.0.tar.gz"
    sha256 "6b38b6ece7296b5e122c9eb17da2eeab3d98a198f50ca9efd00fb03e5b4fd4ae"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "w3lib" do
    url "https:files.pythonhosted.orgpackages47790c62d246fcc9e6fe520c196fe4dad2070db64692bde49c15c4f71fe7d1cbw3lib-2.1.2.tar.gz"
    sha256 "ed5b74e997eea2abe3c1321f916e344144ee8e9072a6f33463ee8e57f858a4b1"
  end

  resource "zope-interface" do
    url "https:files.pythonhosted.orgpackages2abda30bf6df24480017171da4f52ee527a72c7a6450c86355011e0156e71723zope.interface-6.3.tar.gz"
    sha256 "f83d6b4b22262d9a826c3bd4b2fbfafe1d0000f085ef8e44cd1328eea274ae6a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}scrapy version")

    system "#{bin}scrapy", "startproject", "brewproject"
    cd testpath"brewproject" do
      system "#{bin}scrapy", "genspider", "-t", "basic", "brewspider", "brew.sh"
      assert_match "INFO: Spider closed (finished)", shell_output("#{bin}scrapy crawl brewspider 2>&1")
    end
  end
end