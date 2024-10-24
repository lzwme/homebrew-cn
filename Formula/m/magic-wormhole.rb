class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https:github.commagic-wormholemagic-wormhole"
  url "https:files.pythonhosted.orgpackages1ba832a54e75643206665f569dac6ab19727aefb508b148882f1d05dff003667magic_wormhole-0.17.0.tar.gz"
  sha256 "142c7a271684b0b04470792601848f6b0ade0d8bf54fbcb30c6259d75edd9d06"
  license "MIT"
  head "https:github.commagic-wormholemagic-wormhole.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7ba30a7b56dd79d07a5e59ced7ad16371c7699d6a7ba563bffed6f0c1d6ba5d9"
    sha256 cellar: :any,                 arm64_sonoma:  "0cac7d5305baa972190c80b1a05ef1ed01433db9a9bd33c18b494f0fc0a4eb4e"
    sha256 cellar: :any,                 arm64_ventura: "16fd3c1dad574b4b8efabc2b24f85439b2061e4877a4e31145d06875144e9c00"
    sha256 cellar: :any,                 sonoma:        "e260eee9a60b1954419acb1d392e6f0dc663553ab6fcbc040f28c92f129a3023"
    sha256 cellar: :any,                 ventura:       "6526610beceb090ff78594314b925d1883539e412df6064d9557d5a8ef048ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade67e503ee0b9c6586e3905d3274db85d94c2850730ccf4940d5a5ae371498f"
  end

  depends_on "cryptography"
  depends_on "libsodium"
  depends_on "python@3.13"

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
    url "https:files.pythonhosted.orgpackages8d2dede4ad7fc34ab4482389fa3369d304f2fa22e50770af706678f6a332fa82automat-24.8.1.tar.gz"
    sha256 "b34227cf63f6325b8ad2399ede780675083e439b20c323d376373d8ee6306d88"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "constantly" do
    url "https:files.pythonhosted.orgpackages4d6fcb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324dconstantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "humanize" do
    url "https:files.pythonhosted.orgpackages6a4064a912b9330786df25e58127194d4a5a7441f818b400b155e748a270f924humanize-4.11.0.tar.gz"
    sha256 "e66f36020a2d5a974c504bd2555cf770621dbdbb6d82f94a6857c0b1ea2608be"
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

  resource "iterable-io" do
    url "https:files.pythonhosted.orgpackages40be27d59b5c1d74ecbd26c1142f84b61d6cb04f0d0337697149645f34406b2diterable-io-1.0.0.tar.gz"
    sha256 "fb9e1b739587a9ba0d5c60a3e1eb71246761583bc9f18b3c35bb112b44b18c3c"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesbae901f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages1d676afbf0d507f73c32d21084a79946bfcfca5fbc62a72057e9c23797a737c9pyasn1_modules-0.4.1.tar.gz"
    sha256 "c28e2dbf9c06ad61c71a075c7e0f9fd0f1b0bb2d2ad4377f240d33ac2ab60a7c"
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
    url "https:files.pythonhosted.orgpackages0737b31be7e4b9f13b59cde9dcaeff112d401d49e0dc5b37ed4a9fc8fb12f409setuptools-75.2.0.tar.gz"
    sha256 "753bb6ebf1f465a1912e19ed1d41f403a79173a9acf66a42e7e6aec45c3c16ec"
  end

  resource "spake2" do
    url "https:files.pythonhosted.orgpackagesc54b32ad65f8ff5c49254e218ccaae8fc16900cfc289954fb372686159ebe315spake2-0.9.tar.gz"
    sha256 "421fc4a8d5ac395af7af0206ffd9e6cdf188c105cb1b883d9d683312bb5a9334"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages58836ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  resource "twisted" do
    url "https:files.pythonhosted.orgpackages8bbff30eb89bcd14a21a36b4cd3d96658432d4c590af3c24bbe08ea77fa7bbbbtwisted-24.7.0.tar.gz"
    sha256 "5a60147f044187a127ec7da96d170d49bcce50c6fd36f594e60f4587eff4d394"
  end

  resource "txaio" do
    url "https:files.pythonhosted.orgpackages5191bc9fd5aa84703f874dea27313b11fde505d343f3ef3ad702bddbe20bfd6etxaio-23.1.1.tar.gz"
    sha256 "f9a9216e976e5e3246dfd112ad7ad55ca915606b60b84a757ac769bd404ff704"
  end

  resource "txtorcon" do
    url "https:files.pythonhosted.orgpackagesb99f7815b07d8bc775d9578d9131267bb7ce3e91e31305688736ed796ae724d1txtorcon-24.8.0.tar.gz"
    sha256 "befe19138d9c8c5307b6ee6d4fe446d0c201ffd1cc404aeb265ed90309978ad0"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "zipstream-ng" do
    url "https:files.pythonhosted.orgpackagesac165d9224baf640214255c34a0a0e9528c8403d2b89e2ba7df9d7cada58beb1zipstream_ng-1.8.0.tar.gz"
    sha256 "b7129d2c15d26934b3e1cb22256593b6bdbd03c553c26f4199a5bf05110642bc"
  end

  resource "zope-interface" do
    url "https:files.pythonhosted.orgpackages3cf51079cab32302359cc09bd1dca9656e680601e0e8af9397322ab0fe85f368zope.interface-7.1.1.tar.gz"
    sha256 "4284d664ef0ff7b709836d4de7b13d80873dc5faeffc073abdb280058bfac5e3"
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