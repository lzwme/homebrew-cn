class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https:robotframework.org"
  url "https:files.pythonhosted.orgpackagesd285824b95cd3fcaf0eb6c353481b415871da4186e6414ba06a99772a48b960erobotframework-7.1.1.zip"
  sha256 "f85919c68c4d0837006e5f09dde1ef689f082eba2e7e64d5758753f9ee8bfea9"
  license "Apache-2.0"
  head "https:github.comrobotframeworkrobotframework.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "85021b49e6d8945e24e44cb5989cb2a7a32082037292d121a59284c53be16401"
    sha256 cellar: :any,                 arm64_sonoma:  "ec81bb1a717b0861eb38d5fa1e7618bc122d2cd4463c42620d9dfcb79b859548"
    sha256 cellar: :any,                 arm64_ventura: "aab631daa7ff04ac8578c54d2a06b8960ba110e4c9d39295102b15b2da425775"
    sha256 cellar: :any,                 sonoma:        "af4e5212c4be1fd71ef02a08f3d15d061455dbbec47f0e60a0789bc09277e492"
    sha256 cellar: :any,                 ventura:       "24fce9ee9322df17692891851adb00801c4428f90dbbe570b6b546cef9834abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bf758dab49665320d4166fbc75a506bc19cd5930e822a5bbfeb641fb931636c"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "python@3.13"

  uses_from_macos "zlib"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagese47ed95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
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
    url "https:files.pythonhosted.orgpackages1b0fc00296e36ff7485935b83d466c4f2cf5934b84b0ad14e81796e1d9d3609bparamiko-3.5.0.tar.gz"
    sha256 "ad11e540da4f55cedda52931f1a3f812a8238a7af7f62a60de538cd80bb28124"
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
    url "https:files.pythonhosted.orgpackagese6ce97f650115c3a9b2fc8b5b4c7bff93d3582713de6c29e06436eb7321b6ff2robotframework-seleniumlibrary-6.3.0.tar.gz"
    sha256 "5846f5ca4f1729567f9c8b10a3bb191601c654e6c04b952194310434da8e6826"
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
    url "https:files.pythonhosted.orgpackages0e5ad3735b189b91715fd0f5a9b8d55e2605061309849470e96ab830f02cba40selenium-4.25.0.tar.gz"
    sha256 "95d08d3b82fb353f3c474895154516604c7f0e6a9a565ae6498ef36c9bac6921"
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
    url "https:files.pythonhosted.orgpackages17d1a83dee5be404da7afe5a71783a33b8907bacb935a6dc8c69ab785e4a3eedtrio-0.27.0.tar.gz"
    sha256 "1dcc95ab1726b2da054afea8fd761af74bad79bd52381b84eae408e983c76831"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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