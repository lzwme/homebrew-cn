class Fava < Formula
  include Language::Python::Virtualenv

  desc "Web interface for the double-entry bookkeeping software Beancount"
  homepage "https:beancount.github.iofava"
  url "https:files.pythonhosted.orgpackages6a4a694da35174363fe5370563de23c6136d93ff9fa884335452e9aeb35d3b21fava-1.27.tar.gz"
  sha256 "336b84fbf85850ffe5f65e733ff94726c6cccdf43bedc109045cdb997dbd8333"
  license "MIT"
  head "https:github.combeancountfava.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ed8af8e56602f6d929dbc3544e8e785e239e3881f6fd805dca23c3b7642f3cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53218b00bb81a7d2f8a601f63aad2d0d57ad6f3131df93ac27c0c805995888f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3fe07ff7b648e837a01b418a8d2efab9392612f16355f90ba175725bd610d1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9bb98c2545a514da9604cc90c599ddbd3b0c425155b1d1dca1451f411238c66"
    sha256 cellar: :any_skip_relocation, ventura:        "03a21d1d424b6e751968982f1854be2902d96ed7d53db60944725ff6f4f7cd9d"
    sha256 cellar: :any_skip_relocation, monterey:       "3f612102b613350c9ff84bbc9ff387dab8b400bbe65d973366ada980aeedeac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1d11274fdc4df2e02dc16b5a8a85e2714bc5fb2777817cabb43e4f4a942bd9"
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
    url "https:files.pythonhosted.orgpackagese280cfbe44a9085d112e983282ee7ca4c00429bc4d1ce86ee5f4e60259ddff7fBabel-2.14.0.tar.gz"
    sha256 "6919867db036398ba21eb5c7a0f6b28ab8cbc3ae7a73a44ebe34ae74a4e7d363"
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
    url "https:files.pythonhosted.orgpackagesa1136df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9eblinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
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
    url "https:files.pythonhosted.orgpackages2ce456b14d35057a23cab9067dd8fb841407d05d32b5d6c7a3c66c1360e8a7c0google-api-core-2.15.0.tar.gz"
    sha256 "abc978a72658f14a2df1e5e12532effe40f94f868f6e23d95133bd6abcca35ca"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages13be92a5451a52fe40720460848e514b53682a120952740d7b68087f870c3241google-api-python-client-2.113.0.tar.gz"
    sha256 "bcffbc8ffbad631f699cf85aa91993f3dc03060b234ca9e6e2f9135028bd9b52"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackagesbcc0b5119831db4888e703b2adaa912709931181678ae3a50ca08d51a3904765google-auth-2.26.1.tar.gz"
    sha256 "54385acca5c0fbdda510cd8585ba6f3fcb06eeecf8a6ecca39d3ee148b092590"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages4a5feb12d721b45d20a977289d674e179995a0ddab1684d2c61b29a63d43a5f1googleapis-common-protos-1.62.0.tar.gz"
    sha256 "83f0ece9f94e5672cced82f592d2a5edf527a96ed1794f0bab36d5735c996277"
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
    url "https:files.pythonhosted.orgpackages577cfe770e264913f9a49ddb9387cca2757b8d7d26f06735c1bfbb018912afcejaraco.functools-4.0.0.tar.gz"
    sha256 "c279cb24c93d694ef7270f970d499cab4d3813f4e08273f95398651a634f0925"
  end

  resource "markdown2" do
    url "https:files.pythonhosted.orgpackages3ce487a454674ac303e2ca6c25713845d2ae1b59c1a88576054cbec25aaebad1markdown2-2.4.12.tar.gz"
    sha256 "1bc8692696954d597778e0e25713c14ca56d87992070dedd95c17eddaf709204"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagesdfad7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "pdfminer2" do
    url "https:files.pythonhosted.orgpackages55180a856200ff54db80612f66878f9b037ddb9c873f885bc58339b528611994pdfminer2-20151206.tar.gz"
    sha256 "7d05aa3dd1e779080fef13aef454501b51a3f7649d7f18e78c640bdbd34e1e77"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages595fb2d00e6a08d97656a27832d4d146e03ffc46ae74b4699740674bea13a905protobuf-4.25.1.tar.gz"
    sha256 "57d65074b4f5baa4ab5da1605c02be90ac20c8b40fb137d6a8df9f416b0d0ce2"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagescedc996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages3be47dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070fpyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages801f9d8e98e4133ffb16c90f3b405c43e38d3abb715bb5d7a63a5a684f7e46a3pytest-7.4.4.tar.gz"
    sha256 "2cf0005922c6ace4a3e2ec8b4080eb0d9753fdc93107415332f50ce9e7994280"
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