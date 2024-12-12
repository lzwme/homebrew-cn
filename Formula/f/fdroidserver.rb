class Fdroidserver < Formula
  include Language::Python::Virtualenv

  desc "Create and manage Android app repositories for F-Droid"
  homepage "https:f-droid.org"
  url "https:files.pythonhosted.orgpackagese093dc73b074e49ab0fb8df872863a5851e50ef0902647dbec0b63de3026a7c4fdroidserver-2.3.3.tar.gz"
  sha256 "f0a279e31479ee4e9b1801016b3dcf94223a81b02eb4c16ff69c607d5e73622a"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7e513d8e4274bc10787831bf00decb24a68e71c9e66720cc5127531d1022db0"
    sha256 cellar: :any,                 arm64_sonoma:  "0ac8dfdb32c320fd8e107270d763a585f7ba51b735d8f317caf5a806fe3b6c7a"
    sha256 cellar: :any,                 arm64_ventura: "3b98853c1787b3f7a2a607ec8e57789aac2741ffeb1dd8884d32105f32c8207c"
    sha256 cellar: :any,                 sonoma:        "7ec800071c16fbdbdb3765eafdb230d5c7e04d142dd5ea974757c1c0352befb0"
    sha256 cellar: :any,                 ventura:       "6affa43530ede9954ba548b22269a244a3802568b49f8e74a0b8608d45ca9d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5d9902bb18b1b06843d0fe98d2b5d07e9135dc32c49dcc4b3b200cb2a1a262a"
  end

  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "freetype"
  depends_on "libmagic"  # obviates the need for puremagic
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "qhull"
  depends_on "rclone"
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

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7f03581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
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
    url "https:files.pythonhosted.orgpackages4ae782da0a03e7ba5141f05cce0d302e6eed121ae055e0456ca228bf693984bcasttokens-3.0.0.tar.gz"
    sha256 "0dcd8baa8d62b0c1d118b399b2ddba3c4aff271d0d7a9e0d4c1681c79035bbc7"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackages568cdd696962612e4cd83c40a9e6b3db77bfe65a830f4b9af44098708584686cbcrypt-4.2.1.tar.gz"
    sha256 "6765386e3ab87f569b276988742039baab087b2cdb01e809d74e74503c2faafe"
  end

  resource "biplist" do
    url "https:files.pythonhosted.orgpackages3e562db170a498c9c6545cda16e93c2f2ef9302da44802787b45a8a520d01bdbbiplist-1.0.3.tar.gz"
    sha256 "4c0549764c5fe50b28042ec21aa2e14fe1a2224e239a1dae77d9e7f3932aa4c6"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https:files.pythonhosted.orgpackages25c2fc7193cc5383637ff390a712e88e4ded0452c9fbcf84abe3de5ea3df1866contourpy-1.3.1.tar.gz"
    sha256 "dfd97abd83335045a913e3bcc4a09c0ceadbe66580cf573fe961f4a825efa699"
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
    url "https:files.pythonhosted.orgpackages8ce37d45f492c2c4a0e8e0fad57d081a7c8a0286cdd86372b070cca1ec0caa1eexecuting-2.1.0.tar.gz"
    sha256 "8ea27ddd260da8150fa5a708269c4a10e76161e2496ec3e587da9e3c0fe4b9ab"
  end

  resource "fonttools" do
    url "https:files.pythonhosted.orgpackages7661a300d1574dc381393424047c0396a0e213db212e28361123af9830d71a8dfonttools-4.55.3.tar.gz"
    sha256 "3983313c2a04d6cc1fe9251f8fc647754cf49a61dac6cb1e7249ae67afaafc45"
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
    url "https:files.pythonhosted.orgpackagesb6a1106fd9fa2dd989b6fb36e5893961f82992cf676381707253e0bf93eb1662GitPython-3.1.43.tar.gz"
    sha256 "35f314a9f878467f5453cc1fee295c3e18e52f1b99f10f6cf5b1682e968a9e7c"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ipython" do
    url "https:files.pythonhosted.orgpackagesd88b710af065ab8ed05649afa5bd1e07401637c9ec9fb7cfda9eac7e91e9fbd4ipython-8.30.0.tar.gz"
    sha256 "cb0a405a306d2995a5cbb9901894d240784a9f341394c6ba3f4fe8c6eb89ff6e"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackages723a79a912fbd4d8dd6fbb02bf69afd3bb72cf0c729bb3063c6f4498603db17ajedi-0.19.2.tar.gz"
    sha256 "4770dc3de41bde3966b02eb84fbcf557fb33cce26ad23da12c742fb50ecb11f0"
  end

  resource "kiwisolver" do
    url "https:files.pythonhosted.orgpackages854d2255e1c76304cbd60b48cee302b66d1dde4468dc5b1160e4b7cb43778f2akiwisolver-1.4.7.tar.gz"
    sha256 "9893ff81bd7107f7b685d3017cc6583daadb4fc26e4a888350df530e41980a60"
  end

  resource "looseversion" do
    url "https:files.pythonhosted.orgpackages647ef13dc08e0712cc2eac8e56c7909ce2ac280dbffef2ffd87bd5277ce9d58blooseversion-1.3.0.tar.gz"
    sha256 "ebde65f3f6bb9531a81016c6fef3eb95a61181adc47b7f949e9c0ea47911669e"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "matplotlib" do
    url "https:files.pythonhosted.orgpackages759f562ed484b11ac9f4bb4f9d2d7546954ec106a8c0f06cc755d6f63e519274matplotlib-3.9.3.tar.gz"
    sha256 "cd5dbbc8e25cad5f706845c4d100e2c8b34691b412b93717ce38d8ae803bcfa5"
  end

  resource "matplotlib-inline" do
    url "https:files.pythonhosted.orgpackages995ba36a337438a14116b16480db471ad061c36c3694df7c2084a0da7ba538b7matplotlib_inline-0.1.7.tar.gz"
    sha256 "8423b23ec666be3d16e16b60bdd8ac4e86e840ebd1dd11a30b9f117f2fa0ab90"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackagesfd1d06475e1cd5264c0b870ea2cc6fdb3e37177c1e565c43f56ff17a10e3937fnetworkx-3.4.2.tar.gz"
    sha256 "307c3669428c5362aab27c8a1260aa8f47c4e91d3891f48be0141738d8d053e1"
  end

  resource "oscrypto" do
    url "https:files.pythonhosted.orgpackages0681a7654e654a4b30eda06ef9ad8c1b45d1534bfd10b5c045d0c0f6b16fecd2oscrypto-1.3.0.tar.gz"
    sha256 "6f5fef59cb5b3708321db7cca56aed8ad7e662853351e7991fcf60ec606d47a4"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages1b0fc00296e36ff7485935b83d466c4f2cf5934b84b0ad14e81796e1d9d3609bparamiko-3.5.0.tar.gz"
    sha256 "ad11e540da4f55cedda52931f1a3f812a8238a7af7f62a60de538cd80bb28124"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackages669468e2e17afaa9169cf6412ab0f28623903be73d1b32e208d9e8e541bb086dparso-0.8.4.tar.gz"
    sha256 "eb3a7b58240fb99099a345571deecc0f9540ea5f4dd2fe14c2a99d6b281ab92d"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagescabcf35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbfpathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackages2d4ffeb5e137aff82f7c7f3248267b97451da3644f6cdc218edfe549fb354127prompt_toolkit-3.0.48.tar.gz"
    sha256 "d6623ab0477a80df74e646bdbc93621143f5caf104206aa29294d53de1a03d90"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https:files.pythonhosted.orgpackagescd050a34433a064256a578f1783a10da6df098ceaa4a57bbeaa96a6c0352786bpure_eval-0.2.3.tar.gz"
    sha256 "5f4e983f40564c576c7c8635ae88db5956bb2229d7e9237d03b3c0b0190eaf42"
  end

  resource "pycountry" do
    url "https:files.pythonhosted.orgpackages7657c389fa68c50590881a75b7883eeb3dc15e9e73a0fdc001cdd45c13290c92pycountry-24.6.1.tar.gz"
    sha256 "b61b3faccea67f87d10c1f2b0fc0be714409e8fcdcc1315613174f6466c10221"
  end

  resource "pydot" do
    url "https:files.pythonhosted.orgpackagesbfb8500a772825c7ca87e4fd69c3bd6740e3375d6792a7065dd92759249f223dpydot-3.0.3.tar.gz"
    sha256 "5e009d97b2fff92b7a88f09ec1fd5b163f07f3b10469c927d362471d6faa0d50"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8cd5e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-magic" do
    url "https:files.pythonhosted.orgpackagesdadb0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "python-vagrant" do
    url "https:files.pythonhosted.orgpackages2b3f2e42a44c9705d72d9925fe8daf00f31bcf82e8b84ec5a752a8a1357c3ef8python-vagrant-1.0.0.tar.gz"
    sha256 "a8fe93ccf2ff37ecc95ec2f49ea74a91a6ce73a4db4a16a98dd26d397cfd09e5"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "qrcode" do
    url "https:files.pythonhosted.orgpackagesd7db6fc9631cac1327f609d2c8ae3680ecd987a2e97472437f2de7ead1235156qrcode-8.0.tar.gz"
    sha256 "025ce2b150f7fe4296d116ee9bad455a6643ab4f6e7dce541613a4758cbce347"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages46a96ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3cruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "sdkmanager" do
    url "https:files.pythonhosted.orgpackagesb83534c209e688fbc86a99054d9ab86d9ea3656ba2d7986117b9113209528bcbsdkmanager-0.6.10.tar.gz"
    sha256 "e08b402a4b8d19aa6c983c8cfc3328de5c5d2fdfaf96f55a2b67610e0297d599"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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
    url "https:files.pythonhosted.orgpackageseb7972064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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
    venv = virtualenv_install_with_resources without: "matplotlib"

    # `matplotlib` needs extra inputs to use system libraries.
    # Ref: https:github.commatplotlibmatplotlibblobv3.9.2docinstalldependencies.rst#use-system-libraries
    resource("matplotlib").stage do
      python = venv.root"binpython"
      system python, "-m", "pip", "install", "--config-settings=setup-args=-Dsystem-freetype=true",
                                             "--config-settings=setup-args=-Dsystem-qhull=true",
                                             *std_pip_args(prefix: false, build_isolation: true), "."
    end

    bash_completion.install "completionbash-completion" => "fdroid"
    doc.install "examples"
  end

  def caveats
    s = <<~EOS
      For complete functionality, fdroidserver requires that the
      Android SDK's "build-tools" and "platform-tools" are installed,
      and those require a Java JDK.  Also, it is best if the base path
      of the Android SDK is set in the environment variable ANDROID_HOME.
    EOS
    on_macos do
      s += <<~EOS
        To do this all from the command line, run:

          brew install --cask android-commandlinetools temurin
          export ANDROID_HOME=#{share}android-commandlinetools
          $ANDROID_HOMEcmdline-toolslatestbinsdkmanager "platform-tools" "build-tools;34.0.0"
      EOS
    end
    s
  end

  test do
    # locales aren't set correctly within the testing environment
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"

    # fdroid prefers to work in a dir called 'fdroid'
    mkdir testpath"fdroid" do
      mkdir "repo"
      mkdir "metadata"

      (testpath"fdroidconfig.yml").write <<~YAML
        gradle: gradle
      YAML

      (testpath"fdroidconfigcategories.yml").write <<~YAML
        Development:
          name: Development
          icon: category_development.png
        System:
          name: System
          icon: category_system.png
      YAML

      cp test_fixtures("test.png"), testpath"fdroidconfigcategory_development.png"
      cp test_fixtures("test.png"), testpath"fdroidconfigcategory_system.png"

      (testpath"fdroidmetadatafake.yml").write <<~YAML
        Categories:
          - Development
        License: GPL-3.0-or-later

        Summary: Yup still fake
        Description: this is fake

        AutoUpdateMode: None
        UpdateCheckMode: None
      YAML

      system bin"fdroid", "install", "--verbose", "--yes"
      system bin"fdroid", "lint", "--verbose"
      system bin"fdroid", "rewritemeta", "fake", "--verbose"
      system bin"fdroid", "scanner", "--verbose"
    end
  end
end