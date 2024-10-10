class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https:robotframework.org"
  url "https:files.pythonhosted.orgpackagesdf8bb4bb3daf4e11a1b1793ff136d8eeb80a53b44581e3a4f6746274246dc876robotframework-7.1.zip"
  sha256 "34796d387e182b36f05d82f3bbc802bd6a30192ebf1e03c76d2086d0d04faaff"
  license "Apache-2.0"
  head "https:github.comrobotframeworkrobotframework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c5c2fed63f01c15867e141cb49bfe792a58b4e47bd20abe909d10bb04e1dcfa0"
    sha256 cellar: :any,                 arm64_sonoma:   "b876375692f16154f50e12fc26a0c4865cceda4ae6e2482494ba9ff073e12a42"
    sha256 cellar: :any,                 arm64_ventura:  "00ab684eba582bf60e5151b479829292ce4ba0a6fab35872bb1f9957f5e9d0f6"
    sha256 cellar: :any,                 arm64_monterey: "12da509fcffdcb697d49935fd4cf40d52ed18d8338045cbcbec21e8181cadc91"
    sha256 cellar: :any,                 sonoma:         "815855a551d42ea8098c31996d6193e9f0693a2de2691d22d9fcf39b3d88ee78"
    sha256 cellar: :any,                 ventura:        "cf5ff2eb5052f66ed9197189c446550664b06859b6b7c4e03a696352a52d9420"
    sha256 cellar: :any,                 monterey:       "7b4232e6d3624a0618725e5c31d5c4d1fca11bd3a56742cd069e62e976c8b9b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d0f06fd7e5f2c17ddaf499f1a7c3a7f80b84499ea15c6b4392f5197e54945aa"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "zlib"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagese47ed95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "outcome" do
    url "https:files.pythonhosted.orgpackages98df77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages0b6a1d85cc9f5eaf49a769c7128039074bbb8127aba70756f05dfcf4326e72a1paramiko-3.4.1.tar.gz"
    sha256 "8b15302870af7f6652f2e038975c1d2973f06046cb5d7d65355668b3ecbece0c"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "robotframework-archivelibrary" do
    url "https:files.pythonhosted.orgpackagesfb20a41b8c6694491c3cba5cb22f20a18015df1ed03fed78decafd60c254460frobotframework-archivelibrary-0.4.2.tar.gz"
    sha256 "c2ae4d8b16aa79686cbc583e504d17c05852a41560a05d34811d815a9e1d5e79"
  end

  resource "robotframework-pythonlibcore" do
    url "https:files.pythonhosted.orgpackages71895dc8c8186c897ee4b7d0b2631ebc90e679e8c8f04ea85505f96ad38aad64robotframework-pythonlibcore-4.4.1.tar.gz"
    sha256 "2d695b2ea906f5815179643e29182466675e682d82c5fa9d1009edfae2f84b16"
  end

  resource "robotframework-selenium2library" do
    url "https:files.pythonhosted.orgpackagesc47d3c07081e7f0f1844aa21fd239a0139db4da5a8dc219d1e81cb004ba1f4e2robotframework-selenium2library-3.0.0.tar.gz"
    sha256 "2a8e942b0788b16ded253039008b34d2b46199283461b294f0f41a579c70fda7"
  end

  resource "robotframework-seleniumlibrary" do
    url "https:files.pythonhosted.orgpackages984e70d7b368c11180ad025c1f542a20f6bd80ed7c7a7bb14a02380998eecb29robotframework_seleniumlibrary-6.6.1.tar.gz"
    sha256 "6fd3a20c0ca70425d2c4b89e372d2c2399aa059a815c8cab87a2616bcfece7b4"
  end

  resource "robotframework-sshlibrary" do
    url "https:files.pythonhosted.orgpackages23e974f3345024645a1e874c53064787a324eaecfb0c594c189699474370a147robotframework-sshlibrary-3.8.0.tar.gz"
    sha256 "aedf8a02bcb7344404cf8575d0ada25d6c7dc2fcb65de2113c4e07c63d2446c2"
  end

  resource "scp" do
    url "https:files.pythonhosted.orgpackagesd61cd213e1c6651d0bd37636b21b1ba9b895f276e8057f882c9f944931e4f002scp-0.15.0.tar.gz"
    sha256 "f1b22e9932123ccf17eebf19e0953c6e9148f589f93d91b872941a696305c83f"
  end

  resource "selenium" do
    url "https:files.pythonhosted.orgpackageseeba02f65b140f47c85a9d52c67cb19417ec8c97eb46547c3aa93f2b077fa276selenium-4.24.0.tar.gz"
    sha256 "88281e5b5b90fe231868905d5ea745b9ee5e30db280b33498cc73fb0fa06d571"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sortedcontainers" do
    url "https:files.pythonhosted.orgpackagese8c4ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "trio" do
    url "https:files.pythonhosted.orgpackages9a03ab0e9509be0c6465e2773768ec25ee0cb8053c0b91471ab3854bbf2294b2trio-0.26.2.tar.gz"
    sha256 "0346c3852c15e5c7d40ea15972c4805689ef2cb8b5206f794c9c19450119f3a4"
  end

  resource "trio-websocket" do
    url "https:files.pythonhosted.orgpackagesdd36abad2385853077424a11b818d9fd8350d249d9e31d583cb9c11cd4c85edatrio-websocket-0.11.1.tar.gz"
    sha256 "18c11793647703c158b1f6e62de638acada927344d534e3c7628eedcb746839f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagese630fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"HelloWorld.robot").write <<~EOS
      *** Settings ***
      Library         HelloWorld.py

      *** Test Cases ***
      HelloWorld
          Hello World
    EOS

    (testpath"HelloWorld.py").write <<~EOS
      def hello_world():
          print("HELLO WORLD!")
    EOS
    system bin"robot", testpath"HelloWorld.robot"
  end
end