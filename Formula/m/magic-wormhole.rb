class MagicWormhole < Formula
  include Language::Python::Virtualenv

  desc "Securely transfers data between computers"
  homepage "https:github.commagic-wormholemagic-wormhole"
  url "https:files.pythonhosted.orgpackages1a55b82ace1c0c090bc6f629a93f3fb1ed60436731b166de2454d1585532c86fmagic-wormhole-0.16.0.tar.gz"
  sha256 "14e6c146898dbda7a6d190262623a69419955363e7e434d64aad2d233d6d94c9"
  license "MIT"
  head "https:github.commagic-wormholemagic-wormhole.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "19de0a8a829263e8cd5a4add80f8b9ad93fe317f3b8a45cb1ec90a042ea69747"
    sha256 cellar: :any,                 arm64_sonoma:  "bb3f09e8cd974dd3f7a092cc3c0e5a112ea629115d287b6023abaab95e10ef0f"
    sha256 cellar: :any,                 arm64_ventura: "51b42906cc499a3c9eb207f8302c498ce833f298270a8c99e2dbc8792071b100"
    sha256 cellar: :any,                 sonoma:        "797e256edb2794079c1a21cfaa171322a60c191cc6b8c604d41bf93f98b536b7"
    sha256 cellar: :any,                 ventura:       "c4150286a171cb246fd956a8a5c4774bbe2a9016a65911643d0048f8297ff10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1b5ed9c387defa7c5f13edfa4435054754f796209ef76b34bc2a68be63dd9d"
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
    url "https:files.pythonhosted.orgpackages5db1c8f05d5dc8f64030d8cc71e91307c1daadf6ec0d70bcd6eabdfd9b6f153fhumanize-4.10.0.tar.gz"
    sha256 "06b6eb0293e4b85e8d385397c5868926820db32b9b654b932f57fa41c23c9978"
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
    url "https:files.pythonhosted.orgpackages27b8f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74bsetuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
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
    url "https:files.pythonhosted.orgpackages748c682c8bb3085d2089e09c0b9393a12721d059dc0009da4e0b6faff6370679zipstream-ng-1.7.1.tar.gz"
    sha256 "f92023b9ca578cd7fdd94ec733c65664ecf7ee32493e38cdf8e365a1316e9ffc"
  end

  resource "zope-interface" do
    url "https:files.pythonhosted.orgpackagesc8837de03efae7fc9a4ec64301d86e29a324f32fe395022e3a5b1a79e376668ezope.interface-7.0.3.tar.gz"
    sha256 "cd2690d4b08ec9eaf47a85914fe513062b20da78d10d6d789a792c0b20307fb1"
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