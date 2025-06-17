class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https:robotframework.org"
  url "https:files.pythonhosted.orgpackagesafbea5088f9db262f2cf30f87c64be8873ee7f4631190a12a70d361f78b6c62frobotframework-7.3.1.tar.gz"
  sha256 "10be47f826a5ecff09d08e57bf17fce124d38b6e022b380ce67c526ef747194f"
  license "Apache-2.0"
  head "https:github.comrobotframeworkrobotframework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5939ca8cf4593c2d2fc829e110904d7eb93b4031c0cfd5edabb785502c852ac7"
    sha256 cellar: :any,                 arm64_sonoma:  "7b8ec484b4c06a7652cb69effcfd95464aaacdcf0bb39714657a4e2132a5771c"
    sha256 cellar: :any,                 arm64_ventura: "09a53a30feaad03397c97ee951eb8155a044768f419f77b2113f731e6944633c"
    sha256 cellar: :any,                 sonoma:        "7b3053d3dfa2af205ba2c9206e7ffa2d0a16e9ac11359898d5b3be2e70b6202f"
    sha256 cellar: :any,                 ventura:       "91a71455f10c6828af49c33e39332fc29d0be3dd2b01e9f208a6c2a7ff5676b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e1713ce04961ef3b66479bd07e23ff72dc56b8d0b89d11175bfaa31a132f2f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5ae406658f7d5a04ceec0e378f5a0ca2682f8bd0a903c215fc39ec9218bc154"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "python@3.13"

  uses_from_macos "zlib"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagesbb5d6d7433e0f3cd46ce0b43cd65e1db465ea024dbb8216fb2404e919c2ad77bbcrypt-4.3.0.tar.gz"
    sha256 "3a3fd2204178b6d2adcf09cb4f6426ffef54762577a7c9b54c159008cb288c18"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackages01ee02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "outcome" do
    url "https:files.pythonhosted.orgpackages98df77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages7d15ad6ce226e8138315f2451c2aeea985bf35ee910afb477bae7477dc3a8f3bparamiko-3.5.1.tar.gz"
    sha256 "b2c665bc45b2b215bd7d7f039901b14b067da00f3a11e6640995fd58f2664822"
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
    url "https:files.pythonhosted.orgpackagesef5982904e6a51bce72a1812b05da613577c5615a1c72022ba12abd688994d19robotframework-archivelibrary-0.4.3.tar.gz"
    sha256 "d5c94e52c01fb0faf8b2ff3e0bbd41951e81980a94bc406d1b9d6fa695ff1744"
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
    url "https:files.pythonhosted.orgpackagese4b9bca261b0e6cff5dee3b62a0d0516732e43164285212b189679e68effec32robotframework_seleniumlibrary-6.7.1.tar.gz"
    sha256 "3f3aaf7d683b3d619de0ce4849ff9ac33117dd8630f4d7528b4bf0a6d06d6616"
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
    url "https:files.pythonhosted.orgpackages5f7e4145666dd275760b56d0123a9439915af167932dd6caa19b5f8b281ae297selenium-4.33.0.tar.gz"
    sha256 "d90974db95d2cdeb34d2fb1b13f03dc904f53e6c5d228745b0635ada10cd625d"
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
    url "https:files.pythonhosted.orgpackages01c168d582b4d3a1c1f8118e18042464bb12a7c1b75d64d75111b297687041e3trio-0.30.0.tar.gz"
    sha256 "0781c857c0c81f8f51e0089929a26b5bb63d57f927728a5586f7e36171f064df"
  end

  resource "trio-websocket" do
    url "https:files.pythonhosted.orgpackagesd13c8b4358e81f2f2cfe71b66a267f023a91db20a817b9425dd964873796980atrio_websocket-0.12.2.tar.gz"
    sha256 "22c72c436f3d1e264d0910a3951934798dcc5b00ae56fc4ee079d46c7cf20fae"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
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
    (testpath"HelloWorld.robot").write <<~ROBOT
      *** Settings ***
      Library         HelloWorld.py

      *** Test Cases ***
      HelloWorld
          Hello World
    ROBOT

    (testpath"HelloWorld.py").write <<~PYTHON
      def hello_world():
          print("HELLO WORLD!")
    PYTHON
    system bin"robot", testpath"HelloWorld.robot"
  end
end