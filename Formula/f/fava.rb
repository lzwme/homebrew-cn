class Fava < Formula
  include Language::Python::Virtualenv

  desc "Web interface for the double-entry bookkeeping software Beancount"
  homepage "https:beancount.github.iofava"
  url "https:files.pythonhosted.orgpackages586a2fbb724e81f5b62e335c9f01a96ae6a0b20130c3eb8a67aa889722863833fava-1.28.tar.gz"
  sha256 "b161d5911d3fd15306cc7e4e3313822b8bac7fb1b4a1dcccb6bf3611245086b9"
  license "MIT"
  head "https:github.combeancountfava.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "305155deec0f2a6f892414ca773cacc88d78f7b4cd82de204d97911bd44afb47"
    sha256 cellar: :any,                 arm64_sonoma:   "0c2cc30ce7e28439011417feee8267215da2e42ac57360fc594313939c780db8"
    sha256 cellar: :any,                 arm64_ventura:  "821e1c1e0aa4eea6e39e7bddec40e2ca57fe8154d18d8d6c12da76740c85fc2c"
    sha256 cellar: :any,                 arm64_monterey: "0761eee65a1383c06443a590b569e3bf04a65d122fc129da51012d9fbfcbef26"
    sha256 cellar: :any,                 sonoma:         "f9a73250547c683fa0086182093351256db9cfd1b4bf9d87453ecff6d1996c0b"
    sha256 cellar: :any,                 ventura:        "d3fe13b92fd46c0c43cd57cac2dcf5974e13bd6b6f60d87d86926c2c0c28250a"
    sha256 cellar: :any,                 monterey:       "8613f3e72ffbaf4ec3a6f396627fc791076a27d05d1db1e945b759f0ade60178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16d3320151b3c7debdecbe93445c37aae358cce59949b33cf3d12ea29c6fc492"
  end

  depends_on "rust" => :build # for watchfiles
  depends_on "certifi"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagese6e3c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "babel" do
    url "https:files.pythonhosted.orgpackages15d29671b93d623300f0aef82cde40e25357f11330bdde91743891b22a555bedbabel-2.15.0.tar.gz"
    sha256 "8daf0e265d05768bc6c7a314cf1321e9a123afc328cc635c18622a2f30a04413"
  end

  resource "beancount" do
    url "https:files.pythonhosted.orgpackagesf6b12587862caf3367f2d421be9da278f547296b00b7f9610ca9a94fddd8c709beancount-2.3.6.tar.gz"
    sha256 "801f93bed6b57d2e22436688c489d5a1bf1f76e210f3ced18680757e60d3475a"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackages1e57a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abccblinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "bottle" do
    url "https:files.pythonhosted.orgpackagesfd041c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesb34d27a3e6dd09011649ad5210bdf963765bc8fa81a0827a4fc01bafd2705c5bcachetools-5.3.3.tar.gz"
    sha256 "ba29e2dfa0b8b556606f097407ed1aa62080ee108ab0dc5ec9d6a723a007d105"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cheroot" do
    url "https:files.pythonhosted.orgpackages63e2f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "flask" do
    url "https:files.pythonhosted.orgpackages41e1d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829aflask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "flask-babel" do
    url "https:files.pythonhosted.orgpackages581a4c65e3b90bda699a637bfb7fb96818b0a9bbff7636ea91aade67f6020a31flask_babel-4.0.0.tar.gz"
    sha256 "dbeab4027a3f4a87678a11686496e98e1492eb793cbdd77ab50f4e9a2602a593"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackagesc24142a127bf163d9bf1f21540a3bf41c69b231b88707d8d753680b8878201a6google-api-core-2.19.1.tar.gz"
    sha256 "f4695f1e3650b316a795108a76a1c416e6afb036199d1c1f1f110916df479ffd"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackagesd887ce362b2878602d3b129db4896e4c37c0546606ac4bbffca0cec90805ccb7google-api-python-client-2.136.0.tar.gz"
    sha256 "161c722c8864e7ed39393e2b7eea76ef4e1c933a6a59f9d7c70409b6635f225d"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages6280e143d53aa8d02c3b468d3feaf58a0dd094a8ff1954e2500f9f68a8e8bf8fgoogle-auth-2.31.0.tar.gz"
    sha256 "87805c36970047247c8afe614d4e3af8eceafc1ebba0c679fe75ddd1d575e871"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages0b1a41723ae380fa9c561cbe7b61c4eef9091d5fe95486465ccfc84845877331googleapis-common-protos-1.63.2.tar.gz"
    sha256 "27c5abdffc4911f28101e635de1533fb4cfd2c37fbaa9174587c799fac90aa87"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackagesbc66746091bed45b3683d1026cb13b8b7719e11ccc9857b18d29177a18838dc9jaraco_functools-4.0.1.tar.gz"
    sha256 "d33fa765374c0611b52f8b3a795f8900869aa88c84769d4d1746cd68fb28c3e8"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages63f7ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055blxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "markdown2" do
    url "https:files.pythonhosted.orgpackages7489a6bb59171d0bd5a3b19deb834ec29378a7c8e05bcb0a4dd4e5cb418ea03bmarkdown2-2.4.13.tar.gz"
    sha256 "18ceb56590da77f2c22382e55be48c15b3c8f0c71d6398def387275e6c347a9f"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages013377f586de725fc990d12dda3d4efca4a41635be0f99a987b9cc3a78364c13more-itertools-10.3.0.tar.gz"
    sha256 "e5d93ef411224fbcef366a6e8ddc4c5781bc6359d43412a65dd5964e46111463"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pdfminer2" do
    url "https:files.pythonhosted.orgpackages55180a856200ff54db80612f66878f9b037ddb9c873f885bc58339b528611994pdfminer2-20151206.tar.gz"
    sha256 "7d05aa3dd1e779080fef13aef454501b51a3f7649d7f18e78c640bdbd34e1e77"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages962d02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "ply" do
    url "https:files.pythonhosted.orgpackagese569882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4daply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackages3efce9a65cd52c1330d8d23af6013651a0bc50b6d76bcbdf91fae7cd19c68f29proto-plus-1.24.0.tar.gz"
    sha256 "30b72a5ecafe4406b0d339db35b56c4059064e69227b8c3bda7462397f966445"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages71a5d61e4263e62e6db1990c120d682870e5c50a30fb6b26119a214c7a014847protobuf-5.27.2.tar.gz"
    sha256 "f3ecdef226b9af856075f28227ff2c90ce3a594d092c39bee5513573f25e2714"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagesf700e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackagesa658e993ca5357553c966b9e73cb3475d9c935fe9488746e13ebdf9b80fae508pytest-8.2.2.tar.gz"
    sha256 "de4bb8104e201939ccdc688b27a89a7be2079b22e2bd2b07f806b6ba71117977"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-magic" do
    url "https:files.pythonhosted.orgpackagesdadb0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackages79793ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afasimplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "uritemplate" do
    url "https:files.pythonhosted.orgpackagesd25a4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000ebauritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "watchfiles" do
    url "https:files.pythonhosted.orgpackages53e1666771f0746f95c4df767ff98ff17fe55bb0c32ac88ec14ce0615a789330watchfiles-0.22.0.tar.gz"
    sha256 "988e981aaab4f3955209e7e28c7794acdb690be1efa7f16f8ea5aba7ffdadacb"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages02512e0fc149e7a810d300422ab543f87f2bcf64d985eb6f1228c4efd6e4f8d4werkzeug-3.0.3.tar.gz"
    sha256 "097e5bfda9f0aba8da6b8545146def481d06aa7d3266e7448e2cccf67dd8bd18"
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
    sleep 10

    cmd = "curl -sIm1 -XGET http:localhost:#{port}beancountincome_statement"
    assert_match(200 OKm, shell_output(cmd))
  end
end