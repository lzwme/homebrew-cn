class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https:github.commagic-wormholemagic-wormhole"
  url "https:files.pythonhosted.orgpackages9d7b9320062c8b11e58dccd079dd62e3525bf1dac7f2b441c885d64a7ca7f045magic-wormhole-0.15.0.tar.gz"
  sha256 "be2563b5c5547ba333bc6608f048004c8f36d556139bf2ffe3d9f41da2797006"
  license "MIT"
  head "https:github.commagic-wormholemagic-wormhole.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f60592ab428bb92b6a445c5edb81fe5376c31c9ce21c56f3f38bdbf9cc7e47df"
    sha256 cellar: :any,                 arm64_ventura:  "d23dac88d44874b7a9917b8032539ba6472851bab0f4010baa0d706a3955367c"
    sha256 cellar: :any,                 arm64_monterey: "d3cff3fddb93a9a052e1b7d0261c2b8189335a0b0b30be40061eba6390cc793f"
    sha256 cellar: :any,                 sonoma:         "d45eb9eccd13ebfb6a67cde061cb81d0e58761c47deb64d776c24ca74f72180d"
    sha256 cellar: :any,                 ventura:        "4d51faebaa0847676c2dc460ea175fd33ee5490b2050a0acb53ea67d3097d415"
    sha256 cellar: :any,                 monterey:       "0326d85f1e3ab51d119ff7f78cee821358fb89d23324d8f3441a20a43de4c588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc5c6bfc10563b56f477f1015116f3091be79513d7aabd1d75c487917de3de14"
  end

  depends_on "cryptography"
  depends_on "libsodium"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "autobahn" do
    url "https:files.pythonhosted.orgpackages38f28dffb3b709383ba5b47628b0cc4e43e8d12d59eecbddb62cfccac2e7cf6aautobahn-24.4.2.tar.gz"
    sha256 "a2d71ef1b0cf780b6d11f8b205fd2c7749765e65795f2ea7d823796642ee92c9"
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
    url "https:files.pythonhosted.orgpackages2787156b374ff6578062965afe30cc57627d35234369b3336cf244b240c8d8e6incremental-24.7.2.tar.gz"
    sha256 "fb4f1d47ee60efe87d4f6f0ebb5f70b9760db2b2574c59c8e8912be4ebd464c9"
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
    url "https:files.pythonhosted.orgpackages5d70ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "service-identity" do
    url "https:files.pythonhosted.orgpackages38d22ac20fd05f1b6fce31986536da4caeac51ed2e1bb25d4a7d73ca4eccdfabservice_identity-24.1.0.tar.gz"
    sha256 "6829c9d62fb832c2e1c435629b0a8c476e1929881f28bee4d20bc24161009221"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages5e11487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1dsetuptools-72.1.0.tar.gz"
    sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
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
    url "https:files.pythonhosted.orgpackages58836ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
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
    url "https:files.pythonhosted.orgpackagesab4570929649a48b49a71a470bdd84e078110fb5a91e5d74bfe07d65e02b4f03zope.interface-7.0.1.tar.gz"
    sha256 "f0f5fda7cbf890371a59ab1d06512da4f2c89a6ea194e595808123c863c38eff"
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