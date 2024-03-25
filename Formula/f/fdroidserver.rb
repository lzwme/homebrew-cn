class Fdroidserver < Formula
  include Language::Python::Virtualenv

  desc "Create and manage Android app repositories for F-Droid"
  homepage "https:f-droid.org"
  # TODO: Remove `androguard==3.3.5` from pypi_formula_mappings.json in the next release.
  # Ref: https:github.comf-droidfdroidservercommit2f84ce36da2aa79c1583832cd475b1d0be14cca5
  # Ensure `sdkmanager` resource is present. It will be grabbed by `pip` starting in the next release.
  # Ref: https:github.comf-droidfdroidservercommit0dd5a7db648133e3f5ea2dfe1acc381b0541738b
  url "https:files.pythonhosted.orgpackages7572ea1e1e9d7d0ade051279b8676e6025f8c14dd64a5edeb76f2208e23c7720fdroidserver-2.2.1.tar.gz"
  sha256 "6dcba0b747bfc9ebe4d441c56cf0c8aeab70a58cd0d1248462892e933a382302"
  license "AGPL-3.0-or-later"
  revision 4

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "472c209ede812bf37c4ce2dc3477d562a1e910780192d6d4961bc2ba24760f96"
    sha256 cellar: :any,                 arm64_ventura:  "2cb51cc2ba134af20234be792557fe14a60177526583bb81e6e1e8432a83f8ca"
    sha256 cellar: :any,                 arm64_monterey: "540d7df6f2c08a86a4c8d25a620fa0ff5e9ace84ab736a7ed84b6a37841d6b08"
    sha256 cellar: :any,                 sonoma:         "511e5d8f771cc16dace7be0a19875a3ce9f2951f698144bb1f28179c3df6fcb0"
    sha256 cellar: :any,                 ventura:        "0fc47ce46399bf2275a88796dc7007f4d4e7764769a9e6839036a4f665367741"
    sha256 cellar: :any,                 monterey:       "85bda0af3442541b6bfd64b7fec33ea02c53ab0a81eb2ff674ef5cadd86ed311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d04139d5f911c2c6e6312f8659bd832d02aed9543e780341a1f9b6f3fe62e3d"
  end

  depends_on "ninja" => :build
  depends_on "pybind11" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "freetype"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "qhull"
  depends_on "s3cmd"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "androguard" do
    url "https:files.pythonhosted.orgpackages83780f44e8f0fd10493b3118d79d60599c93e5a2cd378d83054014600a620cbaandroguard-3.3.5.tar.gz"
    sha256 "f0655ca3a5add74c550951e79bd0bebbd1c5b239178393d30d8db0bd3202cda2"
  end

  resource "apache-libcloud" do
    url "https:files.pythonhosted.orgpackages1b451a239d9789c75899df8ff53a6b198c1657328f3b333f1711194643d53868apache-libcloud-3.8.0.tar.gz"
    sha256 "75bf4c0b123bc225e24ca95fca1c35be30b19e6bb85feea781404d43c4276c91"
  end

  resource "args" do
    url "https:files.pythonhosted.orgpackagese51cb701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6bargs-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "asn1crypto" do
    url "https:files.pythonhosted.orgpackagesdecfd547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6eeasn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "asttokens" do
    url "https:files.pythonhosted.orgpackages451df03bcb60c4a3212e15f99a56085d93093a497718adf828d050b9d675da81asttokens-2.4.1.tar.gz"
    sha256 "b03869718ba9a6eb027e134bfdf69f38a236d681c83c160d510768af11254ba0"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages72076a6f2047a9dc9d012b7b977e4041d37d078b76b44b7ee4daf331c1e6fb35bcrypt-4.1.2.tar.gz"
    sha256 "33313a1200a3ae90b75587ceac502b048b840fc69e7f7a0905b5f87fac7a1258"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "clint" do
    url "https:files.pythonhosted.orgpackages3db441ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26dclint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "contourpy" do
    url "https:files.pythonhosted.orgpackages11a348ddc7ae832b000952cf4be64452381d150a41a2299c2eb19237168528d1contourpy-1.2.0.tar.gz"
    sha256 "171f311cb758de7da13fc53af221ae47a5877be5a0843a9fe150818c51ed276a"
  end

  resource "cycler" do
    url "https:files.pythonhosted.orgpackagesa995a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "executing" do
    url "https:files.pythonhosted.orgpackages084185d2d28466fca93737592b7f3cc456d1cfd6bcd401beceeba17e8e792b50executing-2.0.1.tar.gz"
    sha256 "35afe2ce3affba8ee97f2d69927fa823b08b472b7b994e36a52a964b93d16147"
  end

  resource "fonttools" do
    url "https:files.pythonhosted.orgpackages52c0b117fe560be1c7bf889e341d1437c207dace4380b10c14f9c7a047df945bfonttools-4.49.0.tar.gz"
    sha256 "ebf46e7f01b7af7861310417d7c49591a85d99146fc23a5ba82fdb28af156321"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages190dbbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8edgitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackages8f1271a40ffce4aae431c69c45a191e5f03aca2304639264faf5666c2767acc4GitPython-3.1.42.tar.gz"
    sha256 "2d99869e0fef71a73cbd242528105af1d6c1b108c60dfabd994bf292f76c3ceb"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "ipython" do
    url "https:files.pythonhosted.orgpackages43ac82acd7bf004bc916f45cdb01622f3ef88199465ca6a7ba0bcf22db27226fipython-8.22.2.tar.gz"
    sha256 "2dcaad9049f9056f1fef63514f176c7d41f930daa78d05b82a176202818f2c14"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackagesd69999b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0ajedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "kiwisolver" do
    url "https:files.pythonhosted.orgpackagesb92d226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85eakiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages2bb4bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "matplotlib" do
    url "https:files.pythonhosted.orgpackages9aaa607a121331d5323b164f1c0696016ccc9d956a256771c4d91e311a302f13matplotlib-3.8.3.tar.gz"
    sha256 "7b416239e9ae38be54b028abbf9048aff5054a9aba5416bef0bd17f9162ce161"
  end

  resource "matplotlib-inline" do
    url "https:files.pythonhosted.orgpackagesd9503af8c0362f26108e54d58c7f38784a3bdae6b9a450bab48ee8482d737f44matplotlib-inline-0.1.6.tar.gz"
    sha256 "f887e5f10ba98e8d2b150ddcf4702c1e5f8b3a20005eb0f74bfdbd360ee6f304"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackagesc480a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3canetworkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackagesccaf11996c4df4f9caff87997ad2d3fd8825078c277d6a928446d2b6cf249889paramiko-3.4.0.tar.gz"
    sha256 "aac08f26a31dc4dffd92821527d1682d99d52f9ef6851968114a8728f3c274d3"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackagesa20e41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https:files.pythonhosted.orgpackages975a0bc937c25d3ce4e0a74335222aee05455d6afa2888032185f8ab50cdf6fdpure_eval-0.2.2.tar.gz"
    sha256 "2b45320af6dfaa1750f543d714b6d1c520a1688dec6fd24d339063ce0aaa9ac3"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackagesa4dbfffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackages888772eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587epyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pydot" do
    url "https:files.pythonhosted.orgpackagesd72f482fcbc389e180e7f8d7e7cb06bc5a7c37be6c57939dfb950951d97f2722pydot-2.0.0.tar.gz"
    sha256 "60246af215123fa062f21cd791be67dda23a6f280df09f68919e637a1e4f3235"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages463a31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pypng" do
    url "https:files.pythonhosted.orgpackages93cd112f092ec27cca83e0516de0a3368dbd9128c187fb6b52aaaa7cde39c96dpypng-0.20220715.0.tar.gz"
    sha256 "739c433ba96f078315de54c0db975aee537cbc3e1d0ae4ed9aab0ca1e427e2c1"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-vagrant" do
    url "https:files.pythonhosted.orgpackages2b3f2e42a44c9705d72d9925fe8daf00f31bcf82e8b84ec5a752a8a1357c3ef8python-vagrant-1.0.0.tar.gz"
    sha256 "a8fe93ccf2ff37ecc95ec2f49ea74a91a6ce73a4db4a16a98dd26d397cfd09e5"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "qrcode" do
    url "https:files.pythonhosted.orgpackages3035ad6d4c5a547fe9a5baf85a9edbafff93fc6394b014fab30595877305fa59qrcode-7.4.2.tar.gz"
    sha256 "9dd969454827e127dbd93696b20747239e6d540e082937c90f14ac95b30f5845"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "sdkmanager" do
    url "https:files.pythonhosted.orgpackagesc77f896d48e75f68f685c0a4fae0f5104d5cdee3c2d376ff4cfa5e78a8b5809esdkmanager-0.6.6.tar.gz"
    sha256 "639d91085c921665cdcbb104c24fe41ad7227590cdb1ffc2b0bd4e23b6d31b37"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc81fe026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages8804b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baasmmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "stack-data" do
    url "https:files.pythonhosted.orgpackages28e355dcc2cfbc3ca9c29519eb6884dd1415ecb53b0e934862d3559ddcb7e20bstack_data-0.6.3.tar.gz"
    sha256 "836a778de4fec4dcd1dcd89ed8abff8a221f58308462e1c4aa2a3cf30148f0b9"
  end

  resource "traitlets" do
    url "https:files.pythonhosted.orgpackagesf1b919206da568095bbf2e57f9f7f7cb6b3b2af2af2670f8c83c23a53d6c00cdtraitlets-5.14.1.tar.gz"
    sha256 "8585105b371a04b8316a43d5ce29c098575c2e477850b62b848b964f1444527e"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages163a0d26ce356c7465a19c9ea8814b960f8a36c3b0d07c323176620b7b483e44typing_extensions-4.10.0.tar.gz"
    sha256 "b0abd7c89e8fb96f98db18d86106ff1d90ab692004eb746cf6eda2682f91b3cb"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "yamllint" do
    url "https:files.pythonhosted.orgpackagesda06d8cee5c3dfd550cc0a466ead8b321138198485d1034130ac1393cc49d63eyamllint-1.35.1.tar.gz"
    sha256 "7a003809f88324fd2c877734f2d575ee7881dd9043360657cc8049c809eba6cd"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # `matplotlib` needs extra inputs to use system libraries.
    # Ref: https:github.commatplotlibmatplotlibblobv3.8.3docusersinstallingdependencies.rst#use-system-libraries
    # TODO: Update build to use `--config-settings=setup-args=...` when `matplotlib` switches to `meson-python`.
    ENV["MPLSETUPCFG"] = buildpath"mplsetup.cfg"
    (buildpath"mplsetup.cfg").write <<~EOS
      [libs]
      system_freetype = true
      system_qhull = true
    EOS

    virtualenv_install_with_resources

    bash_completion.install "completionbash-completion" => "fdroid"
    doc.install "examples"
  end

  def caveats
    <<~EOS
      For complete functionality, fdroidserver requires that the
      Android SDK's "build-tools" and "platform-tools" are installed,
      and those require a Java JDK.  Also, it is best if the base path
      of the Android SDK is set in the standard environment variable
      ANDROID_HOME.  To do this all from the command line, run:

        brew install --cask android-commandlinetools temurin
        export ANDROID_HOME=#{share}android-commandlinetools
        $ANDROID_HOMEcmdline-toolslatestbinsdkmanager "platform-tools" "build-tools;34.0.0"
    EOS
  end

  test do
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    # fdroid prefers to work in a dir called 'fdroid'
    mkdir testpath"fdroid" do
      mkdir "repo"
      mkdir "metadata"

      (testpath"fdroidconfig.py").write "gradle = 'gradle'"
      (testpath"fdroidmetadatafake.yml").write <<~EOS
        Categories:
          - Internet
        License: GPL-3.0-or-later

        Summary: Yup still fake
        Description: this is fake

        AutoUpdateMode: None
        UpdateCheckMode: None
      EOS

      system bin"fdroid", "checkupdates", "--verbose", "--allow-dirty"
      system bin"fdroid", "lint", "--verbose"
      system bin"fdroid", "rewritemeta", "fake", "--verbose"
      system bin"fdroid", "scanner", "--verbose"
    end
  end
end