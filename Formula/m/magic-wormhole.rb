class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https:github.commagic-wormholemagic-wormhole"
  url "https:files.pythonhosted.orgpackages89998c8709d8c3e1058ba8b6d9f331529a0e91b484ae0585dd24cd77cb45ad4fmagic-wormhole-0.14.0.tar.gz"
  sha256 "006d239f88bff7c37bc2eff60a004e263faf9258f7279192d06ba0c9ced6b080"
  license "MIT"
  revision 3
  head "https:github.commagic-wormholemagic-wormhole.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1a1776c8668b34079ec996a11ae65d5bc2040edf31f2faf08b0da879f11822b4"
    sha256 cellar: :any,                 arm64_ventura:  "02ba23def84e1d8ff1dc32cabd17e4ecfae36c8c676d0799f61d734c3ddf070d"
    sha256 cellar: :any,                 arm64_monterey: "0e0c545d799c230536b4fc5b6575b6f98eeb004ab2f877ba9f64390e31839b8b"
    sha256 cellar: :any,                 sonoma:         "9442c6479261d57400fe7e7279284a25817e647d4a1d1e632767bb818f9114ce"
    sha256 cellar: :any,                 ventura:        "2ab9c37965a6bc466df14a5398b25d909fee72a891f1ea66b90d12d3d7db7c26"
    sha256 cellar: :any,                 monterey:       "352374fc20b1d4e52dd71bbe673cad29287e83f4baa027a42dfedae1aca46d35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "100cbcac6d7f6d28f0f3ae58c6df8437e2c3fa49618c8fa58f16ada4f6d3188d"
  end

  depends_on "cryptography"
  depends_on "libsodium"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "autobahn" do
    url "https:files.pythonhosted.orgpackages92eec3320c326919394ff597592549ff5d29d2f7bf12be9ddaa9017caff1a170autobahn-23.6.2.tar.gz"
    sha256 "ec9421c52a2103364d1ef0468036e6019ee84f71721e86b36fe19ad6966c1181"
  end

  resource "automat" do
    url "https:files.pythonhosted.orgpackages7a7b9c3d26d8a0416eefbc0428f168241b32657ca260fb7ef507596ff5c2f6c4Automat-22.10.0.tar.gz"
    sha256 "e56beb84edad19dcc11d30e8d9b895f75deeb5ef5e96b84a467066b3b84bb04e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "constantly" do
    url "https:files.pythonhosted.orgpackages4d6fcb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324dconstantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "hkdf" do
    url "https:files.pythonhosted.orgpackagesc3be327e072850db181ce56afd51e26ec7aa5659b18466c709fa5ea2548c935fhkdf-0.0.3.tar.gz"
    sha256 "622a31c634bc185581530a4b44ffb731ed208acf4614f9c795bdd70e77991dca"
  end

  resource "humanize" do
    url "https:files.pythonhosted.orgpackages5db1c8f05d5dc8f64030d8cc71e91307c1daadf6ec0d70bcd6eabdfd9b6f153fhumanize-4.10.0.tar.gz"
    sha256 "06b6eb0293e4b85e8d385397c5868926820db32b9b654b932f57fa41c23c9978"
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

  resource "iterable-io" do
    url "https:files.pythonhosted.orgpackages40be27d59b5c1d74ecbd26c1142f84b61d6cb04f0d0337697149645f34406b2diterable-io-1.0.0.tar.gz"
    sha256 "fb9e1b739587a9ba0d5c60a3e1eb71246761583bc9f18b3c35bb112b44b18c3c"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagesf700e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages91a8cbeec652549e30103b9e6147ad433405fdd18807ac2d54e6dbb73184d8a1pyOpenSSL-24.1.0.tar.gz"
    sha256 "cabed4bfaa5df9f1a16c0ef64a0cb65318b5cd077a7eda7d6970131ca2f41a6f"
  end

  resource "service-identity" do
    url "https:files.pythonhosted.orgpackages38d22ac20fd05f1b6fce31986536da4caeac51ed2e1bb25d4a7d73ca4eccdfabservice_identity-24.1.0.tar.gz"
    sha256 "6829c9d62fb832c2e1c435629b0a8c476e1929881f28bee4d20bc24161009221"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages65d810a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "spake2" do
    url "https:files.pythonhosted.orgpackages600bbb5eca8e18c38a10b1c207bbe6103df091e5cf7b3e5fdc0efbcad7b85b60spake2-0.8.tar.gz"
    sha256 "c17a614b29ee4126206e22181f70a406c618d3c6c62ca6d6779bce95e9c926f4"

    # Update versioneer script for 3.12. Remove if mergedreleased
    # https:github.comwarnerpython-spake2pull15
    patch do
      url "https:github.comwarnerpython-spake2commit5079cc963305c8aa6465e2a4bbbb08781fb49d3b.patch?full_index=1"
      sha256 "2e095162aeb910eb5ca399763499b414b400bcf5cf59fd851f5810d7b6d11646"
    end
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages5ac0b7599d6e13fe0844b0cda01b9aaef9a0e87dbb10b06e4ee255d3fa1c79a2tqdm-4.66.4.tar.gz"
    sha256 "e4d936c9de8727928f3be6079590e97d9abfe8d39a590be678eb5919ffc186bb"
  end

  resource "twisted" do
    url "https:files.pythonhosted.orgpackagesfc8d9c09d75173984d3b0f0dcf65d885fe61a06de11db2c30b1196d85f631cfctwisted-24.3.0.tar.gz"
    sha256 "6b38b6ece7296b5e122c9eb17da2eeab3d98a198f50ca9efd00fb03e5b4fd4ae"
  end

  resource "txaio" do
    url "https:files.pythonhosted.orgpackages5191bc9fd5aa84703f874dea27313b11fde505d343f3ef3ad702bddbe20bfd6etxaio-23.1.1.tar.gz"
    sha256 "f9a9216e976e5e3246dfd112ad7ad55ca915606b60b84a757ac769bd404ff704"
  end

  resource "txtorcon" do
    url "https:files.pythonhosted.orgpackages39ebdd87610a296ac02aba6a67668e5811e43078ea32d261e0c8eb2d43d6e67ctxtorcon-23.11.0.tar.gz"
    sha256 "71f85ae93d76d726510059c9ed74e608bc5a5c9f7d103853b49e414280406a2f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "zipstream-ng" do
    url "https:files.pythonhosted.orgpackages748c682c8bb3085d2089e09c0b9393a12721d059dc0009da4e0b6faff6370679zipstream-ng-1.7.1.tar.gz"
    sha256 "f92023b9ca578cd7fdd94ec733c65664ecf7ee32493e38cdf8e365a1316e9ffc"
  end

  resource "zope-interface" do
    url "https:files.pythonhosted.orgpackages09067c1202972bc99dd1b731c3c01157855cbc8d0944894c3b234473b1f4119czope.interface-6.4.post2.tar.gz"
    sha256 "1c207e6f6dfd5749a26f5a5fd966602d6b824ec00d2df84a7e9a924e8933654e"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
    man1.install "docswormhole.1"
    bash_completion.install "wormhole_complete.bash"=> "wormhole.bash"
    fish_completion.install "wormhole_complete.fish" => "wormhole.fish"
    zsh_completion.install "wormhole_complete.zsh" => "_wormhole"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    n = rand(1e6)
    pid = fork do
      exec bin"wormhole", "send", "--code=#{n}-homebrew-test", "--text=foo"
    end
    sleep 1
    begin
      received = shell_output("#{bin}wormhole receive #{n}-homebrew-test")
      assert_match received, "foo\n"
    ensure
      Process.wait(pid)
    end
  end
end