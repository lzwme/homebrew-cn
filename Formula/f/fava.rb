class Fava < Formula
  include Language::Python::Virtualenv

  desc "Web interface for the double-entry bookkeeping software Beancount"
  homepage "https:beancount.github.iofava"
  url "https:files.pythonhosted.orgpackages96b77e46aa079d0e66964197d69c629ecfe251d71e4e60bf25eb71209be834d7fava-1.26.2.tar.gz"
  sha256 "fab32e55f7ba04301c66026405bd7c60b1598ab3817da77a5866d6b404f6d6e2"
  license "MIT"
  head "https:github.combeancountfava.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbb89a0f136bf97cb3adb92c3fed9faa4cbdfa87dad16d87c55da9c9f33ab522"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d6e02350daa37f88f8b710c53e94046da1224aa6d0ad27c96564fb9f9676767"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcfd3ec909d20f7017cabd7a93fc605a23f0b5c355b4b1ace8f673b4314b8200"
    sha256 cellar: :any_skip_relocation, sonoma:         "083131fe5fb21b7a8174e96a06600b52a8dbadfffad52874b18d713af057607b"
    sha256 cellar: :any_skip_relocation, ventura:        "4acaa20fb4e5c252fe34ca8e0bf0d2f8ca8efe25d4f50057c305a9d14321fbd1"
    sha256 cellar: :any_skip_relocation, monterey:       "5d4635293da1961cb82ccb7a1864f02f0c1a470c52988a11463e671db8762d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc347f6cff1b86c81a439fb384837c9dbdd9baa87f2159f35e8e2b41df9558cb"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-jinja"
  depends_on "python-lxml"
  depends_on "python-magic"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-pluggy"
  depends_on "python-ply"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "six"

  resource "babel" do
    url "https:files.pythonhosted.orgpackagesaa6c737d2345d86741eeb594381394016b9c74c1253b4cbe274bb1e7b5e2138eBabel-2.13.1.tar.gz"
    sha256 "33e0952d7dd6374af8dbf6768cc4ddf3ccfefc244f9986d4074704f2fbd18900"
  end

  resource "beancount" do
    url "https:files.pythonhosted.orgpackagesf6b12587862caf3367f2d421be9da278f547296b00b7f9610ca9a94fddd8c709beancount-2.3.6.tar.gz"
    sha256 "801f93bed6b57d2e22436688c489d5a1bf1f76e210f3ced18680757e60d3475a"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesaf0b44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackagesea96ed1420a974540da7419094f2553bc198c454cee5f72576e7c7629dd12d6eblinker-1.6.3.tar.gz"
    sha256 "152090d27c1c5c722ee7e48504b02d76502811ce02e1523553b4cf8c8b3d3a8d"
  end

  resource "bottle" do
    url "https:files.pythonhosted.orgpackagesfd041c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackages10211b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "cheroot" do
    url "https:files.pythonhosted.orgpackages087c95c154177b16077de0fec1b821b0d8b3df2b59c5c7b3575a9c1bf52a437echeroot-10.0.0.tar.gz"
    sha256 "59c4a1877fef9969b3c3c080caaaf377e2780919437853fc0d32a9df40b311f0"
  end

  resource "flask" do
    url "https:files.pythonhosted.orgpackagesd809c1a7354d3925a3c6c8cfdebf4245bae67d633ffda1ba415add06ffc839c5flask-3.0.0.tar.gz"
    sha256 "cfadcdb638b609361d29ec22360d6070a77d7463dcb3ab08d2c2f2f168845f58"
  end

  resource "flask-babel" do
    url "https:files.pythonhosted.orgpackages581a4c65e3b90bda699a637bfb7fb96818b0a9bbff7636ea91aade67f6020a31flask_babel-4.0.0.tar.gz"
    sha256 "dbeab4027a3f4a87678a11686496e98e1492eb793cbdd77ab50f4e9a2602a593"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackages3f5d9138d873205a38e5264a78fd4ebf446fc987f20e2566719ed6eee69c200agoogle-api-core-2.12.0.tar.gz"
    sha256 "c22e01b1e3c4dcd90998494879612c38d0a3411d1f7b679eb89e2abe3ce1f553"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages03757a04c88700a6c186bb7e9979c1b2b15d1944bf66453b778ea69e4efcccb6google-api-python-client-2.105.0.tar.gz"
    sha256 "0a8b32cfc2d9b3c1868ae6faef7ee1ab9c89a6cec30be709ea9c97f9a3e5902d"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages45710f19d6f51b6ea291fc8f179d152d675f49acf88cb44f743b37bf51ef2ec1google-auth-2.23.3.tar.gz"
    sha256 "6864247895eea5d13b9c57c9e03abb49cb94ce2dc7c58e91cba3248c7477c9e3"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages0f7a83c3a1f8419d66f91672ad7f2cea57d044f7f0b3c1740389a468ff3937edgoogle-auth-httplib2-0.1.1.tar.gz"
    sha256 "c64bc555fdc6dd788ea62ecf7bccffcf497bf77244887a3f3d7a5a02f8e3fc29"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages9541f9d4425eac5cec8c0356575b8f183e8f1f7206875b1e748bd3af4b4a8a1egoogleapis-common-protos-1.61.0.tar.gz"
    sha256 "8a64866a97f6304a7179873a465d6eee97b7a24ec6cfd78e0f575e96b821240b"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages7fa1d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackagese6f797322b08780ac7f783893991a1ed2a0a8b9c729d06350e2a1c6e7f8687cbjaraco.functools-3.9.0.tar.gz"
    sha256 "8b137b0feacc17fef4bacee04c011c9e86f2341099c870a1d12d3be37b32a638"
  end

  resource "markdown2" do
    url "https:files.pythonhosted.orgpackages8eb364c459af88ea8c2eeb020d0edf3e36c62176e988c47e412133c37c5da5e7markdown2-2.4.10.tar.gz"
    sha256 "cdba126d90dc3aef6f4070ac342f974d63f415678959329cc7909f96cc235d72"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages2d733557e45746fcaded71125c0a1c0f87616e8258c78391f0c365bf97bbfc99more-itertools-10.1.0.tar.gz"
    sha256 "626c369fa0eb37bac0291bce8259b332fd59ac792fa5497b59837309cd5b114a"
  end

  resource "pdfminer2" do
    url "https:files.pythonhosted.orgpackages55180a856200ff54db80612f66878f9b037ddb9c873f885bc58339b528611994pdfminer2-20151206.tar.gz"
    sha256 "7d05aa3dd1e779080fef13aef454501b51a3f7649d7f18e78c640bdbd34e1e77"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages525cf2c0778278259089952f94b0884ca27a001a17ffbd992ebe30c841085f4cprotobuf-4.24.4.tar.gz"
    sha256 "5a70731910cd9104762161719c3d883c960151eea077134458503723b60e3667"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages61ef945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89dpyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages3be47dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070fpyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages38d4174f020da50c5afe9f5963ad0fc5b56a4287e3586e3de5b3c8bce9c547b4pytest-7.4.3.tar.gz"
    sha256 "d989d136982de4e3b29dabcc838ad581c64e8ed52c11fbe86ddebd9da0818cd5"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackages79793ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afasimplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "uritemplate" do
    url "https:files.pythonhosted.orgpackagesd25a4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000ebauritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages0dccff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53dwerkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"fava", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    # Find an available port
    port = free_port

    (testpath"example.ledger").write <<~EOS
      2020-01-01 open Assets:Checking
      2020-01-01 open Equity:Opening-Balances
      2020-01-01 txn "Opening Balance"
        Assets:Checking 10.00 USD
        Equity:Opening-Balances
    EOS

    fork do
      exec bin"fava", "--port=#{port}", testpath"example.ledger"
    end

    # Wait for fava to start up
    sleep 5

    cmd = "curl -sIm1 -XGET http:localhost:#{port}beancountincome_statement"
    assert_match(200 OKm, shell_output(cmd))
  end
end