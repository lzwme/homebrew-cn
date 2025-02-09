class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https:robotframework.org"
  url "https:files.pythonhosted.orgpackages0155e6decd3155929c1ae0156df0219c991377b6e1c19b7c4a2ef88560069724robotframework-7.2.2.tar.gz"
  sha256 "9c420f6d35e9c8cd4b75b77cc78e36407604534ec4ab0cbddf699d7c0b2fc435"
  license "Apache-2.0"
  head "https:github.comrobotframeworkrobotframework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3558e5aaabafce0cae2f67c9acb79c016c383f8feb42a5e48939f20e3e970f96"
    sha256 cellar: :any,                 arm64_sonoma:  "5c45c44f12732699e6305d4210545dac2871f08db082459333aa9894ca09e51f"
    sha256 cellar: :any,                 arm64_ventura: "c3f4ac2aa46986aaae2d1d31691a3d345cff5680223fc787495c8600f1d4451c"
    sha256 cellar: :any,                 sonoma:        "b2e65446ff92261be1a0568c8e5aa2e3a9274a8ae5a90b3dd793abfd67300ee5"
    sha256 cellar: :any,                 ventura:       "2a29e73d22fbdeb146dadca4b0a15673febbc99ae5242bb2523f44cd208ab514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e22eb6fe4c7fba6c267182ae133fcfee19bf51350f8c543b79baffa0b29f2ba"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "python@3.13"

  uses_from_macos "zlib"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages497cfdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17fattrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages568cdd696962612e4cd83c40a9e6b3db77bfe65a830f4b9af44098708584686cbcrypt-4.2.1.tar.gz"
    sha256 "6765386e3ab87f569b276988742039baab087b2cdb01e809d74e74503c2faafe"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
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
    url "https:files.pythonhosted.orgpackages28a6e955df90bf956d13b8a700ab7e09461b96ffd7c8e27e068d6a44a7e86dd4robotframework_seleniumlibrary-6.7.0.tar.gz"
    sha256 "9def0f81d5437604f5f3c3ff6b328fcb3dac888547d39bbb8624440d55114285"
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
    url "https:files.pythonhosted.orgpackages8838d62d4e8da649ad699b02eb1e95c3cfc20ff400744b9417b9093c5daebd4bselenium-4.28.1.tar.gz"
    sha256 "0072d08670d7ec32db901bd0107695a330cecac9f196e3afb3fa8163026e022a"

    # Backport fix to build from source distribution
    # Ref: https:github.comSeleniumHQseleniumcommit9cb1db9392fec6c9b4c617763ed2ee76ed989c5e
    patch :DATA
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
    url "https:files.pythonhosted.orgpackagesb37357efab729506a8d4b89814f1e356ec8f3369de0ed4fd7e7616974d09646dtrio-0.28.0.tar.gz"
    sha256 "4e547896fe9e8a5658e54e4c7c5fa1db748cbbbaa7c965e7d40505b928c73c05"
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
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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

__END__
--- apyproject.toml
+++ bpyproject.toml
@@ -43,9 +43,6 @@ exclude = ["test*"]
 namespaces = true
 # include-package-data is `true` by default in pyproject.toml
 
-[[tool.setuptools-rust.ext-modules]]
-target = "selenium.webdriver.common.selenium-manager"
-
 [[tool.setuptools-rust.bins]]
 target = "selenium.webdriver.common.selenium-manager"