class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "https:www.edge-security.comtheharvester.php"
  url "https:github.comlaramiestheHarvesterarchiverefstags4.7.1.tar.gz"
  sha256 "de59067427427dfea9f446419069fa4f8ad77ce3261426fd812a0d9af28a518f"
  license "GPL-2.0-only"
  head "https:github.comlaramiestheHarvester.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4513319722fcb3694160214af327c3c97a46ffe26127c3fe195b53212f682895"
    sha256 cellar: :any,                 arm64_sonoma:  "e56e6a98f2d7990dcb4a48b2c3057672b22487e28a13640c356e7e0aaa51c865"
    sha256 cellar: :any,                 arm64_ventura: "62cee95195b8e9cb88fec68bb640caceba5d2bec26d8a568ee7276851e95d264"
    sha256 cellar: :any,                 sonoma:        "af74973f684d186fcda85b563937bca4aea7202dfc93e0a484c7f854a2a18ced"
    sha256 cellar: :any,                 ventura:       "33a2fa53523e18189187e42cb907725410ccb452297f833018df0b9f3328dc93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e69bf1c31eceffdf62b354916c4ca50217f6b528f92183198872dfa41d8eca69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fb3002e14bc4976d213a1f15982669f657017a47dfb49571d94e5b3b32dd5e8"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "aiodns" do
    url "https:files.pythonhosted.orgpackagese78441a6a2765abc124563f5380e76b9b24118977729e25a84112f8dfb2b33dcaiodns-3.2.0.tar.gz"
    sha256 "62869b23409349c21b072883ec8998316b234c9a9e36675756e8e317e8768f72"
  end

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackages0b03a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesf1d91c4721d143e14af753f2bf5e3b681883e1f24b592c0482df6fa6e33597faaiohttp-3.11.16.tar.gz"
    sha256 "16f8a2c9538c14a557b4d309ed4d0a7c60f0253e8ed7b6c9a2859a7582f8b1b8"
  end

  resource "aiomultiprocess" do
    url "https:files.pythonhosted.orgpackages02d41e69e17dda5df91734b70d03dbbf9f222ddb438e1f3bf4ea8fa135ce46deaiomultiprocess-0.9.1.tar.gz"
    sha256 "f0231dbe0291e15325d7896ebeae0002d95a4f2675426ca05eb35f24c60e495b"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "aiosqlite" do
    url "https:files.pythonhosted.orgpackages137d8bca2bf9a247c2c5dfeec1d7a5f40db6518f88d314b8bca9da29670d2671aiosqlite-0.21.0.tar.gz"
    sha256 "131bb8056daa3bc875608c631c678cda73922a2d4ba8aec373b19f18c17e7aa3"
  end

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages160f861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesf03cadaf39ce1fb4afdd21b611e3d530b183bb7759c9b673d60db0e347fd4439beautifulsoup4-4.13.3.tar.gz"
    sha256 "1bd32405dacc920b42b83ba01644747ed77456a65760e285fbc47633ceddaf8b"
  end

  resource "censys" do
    url "https:files.pythonhosted.orgpackages086976c19cff1cac71420eb731300f39bbba90308a23a8bca9bd6a6d5bafdeffcensys-2.2.16.tar.gz"
    sha256 "c70680ee84630fba20c3d14f1ed0d9c2a5a2d54009d0821fbaa9fed8119c4ee3"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackagesfc97c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90dcffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-plugins" do
    url "https:files.pythonhosted.orgpackages5f1d45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages989706afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "fastapi" do
    url "https:files.pythonhosted.orgpackagesf455ae499352d82338331ca1e28c7f4a63bfd09479b16395dce38cf50a39e2c2fastapi-0.115.12.tar.gz"
    sha256 "1e2c2a2646905f9e83d32f04a3f86aff4a286669c6c950ca95b5fd68c2602681"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages0a10c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9afilelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8fed0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
  end

  resource "greenlet" do
    url "https:files.pythonhosted.orgpackages2fffdf5fede753cc10f6a5be0931204ea30c35fa2f2ea7a35b25bdaf4fe40e46greenlet-3.1.1.tar.gz"
    sha256 "4ce3ac6cdb6adf7946475d7ef31777c26d94bccc377e070a7986bd2d5c515467"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "limits" do
    url "https:files.pythonhosted.orgpackagesd3037adefba87708cdf195ef574b6170cf9f018fefc4e9744b27eaa666ee4a45limits-4.7.3.tar.gz"
    sha256 "993b9cda18c63e64760756f66190157e641b60919626a2690ca3133e1ed00644"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages8061d3dc048cd6c7be6fe45b80cedcbdd4326ba4d550375f266d9f4246d0f4bclxml-5.3.2.tar.gz"
    sha256 "773947d0ed809ddad824b7b14467e1a481b8976e87278ac4a730c2f7c7fcddc1"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesda2ce367dfb4c6538614a0c9453e510d75d66099edf1c4e69da1b5ce691a1931multidict-6.4.3.tar.gz"
    sha256 "3ada0b058c9f213c5f95ba301f922d402ac234f1111a7d8fd70f1b99f3c281ec"
  end

  resource "netaddr" do
    url "https:files.pythonhosted.orgpackages5490188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229dnetaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "playwright" do
    url "https:github.commicrosoftplaywright-pythonarchiverefstagsv1.51.0.tar.gz"
    sha256 "9c082490a1769eaa1ccb93786e1b1b1ef2257991dd1ab56056f8f4b9601ef85e"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackages07c8fdc6686a986feae3541ea23dcaa661bd93972d3940460646c6bb96e21c40propcache-0.3.1.tar.gz"
    sha256 "40d980c33765359098837527e18eddefc9a24cea5b45e078a7f3bb5b032c6ecf"
  end

  resource "pycares" do
    url "https:files.pythonhosted.orgpackages6cac05e32fe0abecf98b58cb28646d59280ebad8d79b9785ad6771fa830a458bpycares-4.6.0.tar.gz"
    sha256 "b8a004b18a7465ac9400216bc3fad9d9966007af1ee32f4412d2b3a94e33456e"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages102eca897f093ee6c5f3b0bee123ee4465c50e75431c3d5b6a3b44a47134e891pydantic-2.11.3.tar.gz"
    sha256 "7471657138c16adad9322fe3070c0116dd6c3ad8d649300e3cbdfe91f4db4ec3"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages1719ed6a078a5287aea7922de6841ef4c06157931622c89c2a47940837b5eecdpydantic_core-2.33.1.tar.gz"
    sha256 "bcc9c6fdb0ced789245b02b7d6603e17d1563064ddcfc36f046b61c0c05dd9df"
  end

  resource "pyee" do
    url "https:files.pythonhosted.orgpackages0a378fb6e653597b2b67ef552ed49b438d5398ba3b85a9453f8ada0fd77d455cpyee-12.1.1.tar.gz"
    sha256 "bbc33c09e2ff827f74191e3e5bbc6be7da02f627b7ec30d86f5ce1a6fb2424a3"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-file" do
    url "https:files.pythonhosted.orgpackages7297bf44e6c6bd8ddbb99943baf7ba8b1a8485bcd2fe0e55e5708d7fee4ff1aerequests_file-2.1.0.tar.gz"
    sha256 "0f549a3f3b0699415ac04d167e9cb39bccfb730cb832b4d20be3d9867356e658"
  end

  resource "retrying" do
    url "https:files.pythonhosted.orgpackagesce7015ce8551d65b324e18c5aa6ef6998880f21ead51ebe5ed743c0950d7d9ddretrying-1.3.4.tar.gz"
    sha256 "345da8c5765bd982b1d1915deb9102fd3d1f7ad16bd84a9700b85f64d24e8f3e"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "shodan" do
    url "https:files.pythonhosted.orgpackagesc506c6dcc975a1e7d89bc764fd271da8138b318e18080b48e7f1acd2ab63df28shodan-1.31.0.tar.gz"
    sha256 "c73275386ea02390e196c35c660706a28dd4d537c5a21eb387ab6236fac251f6"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "slowapi" do
    url "https:files.pythonhosted.orgpackagesa099adfc7f94ca024736f061257d39118e1542bade7a52e86415a4c4ae92d8ffslowapi-0.1.9.tar.gz"
    sha256 "639192d0f1ca01b1c6d95bf6c71d794c3a9ee189855337b4821f7f457dddad77"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "starlette" do
    url "https:files.pythonhosted.orgpackagesce2008dfcd9c983f6a6f4a1000d934b9e6d626cff8d2eeb77a89a68eef20a2b7starlette-0.46.2.tar.gz"
    sha256 "7f7361f34eed179294600af672f565727419830b54b7b084efe44bb82d2fccd5"
  end

  resource "tldextract" do
    url "https:files.pythonhosted.orgpackages207ae469c4f71231a848492da31a7be6921a6cd04ecc8eed58e924bece0fb6detldextract-5.2.0.tar.gz"
    sha256 "c3a8c4daf2c25a57f54d6ef6762aeac7eff5ac3da04cdb607130be757b8457ab"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackages825ce6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  resource "ujson" do
    url "https:files.pythonhosted.orgpackagesf0003110fd566786bfa542adb7932d62035e0c0ef662a8ff6544b6643b3d6fd7ujson-5.10.0.tar.gz"
    sha256 "b3cd8f3c5d8c7738257f1018880444f7b7d9b66232c64649f562d7ba86ad4bc1"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackages4b4d938bd85e5bf2edeec766267a5015ad969730bb91e31b44021dfe8b22df6cuvicorn-0.34.0.tar.gz"
    sha256 "404051050cd7e905de2c9a7e61790943440b3416f49cb409f965d9dcd0fa73e9"
  end

  resource "uvloop" do
    url "https:files.pythonhosted.orgpackagesafc0854216d09d33c543f12a44b393c402e89a920b1a0a7dc634c42de91b9cf6uvloop-0.21.0.tar.gz"
    sha256 "3bf12b0fda68447806a7ad847bfa591613177275d35b6724b1ee573faa3704e3"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackagesc3fce91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcefwrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "xlsxwriter" do
    url "https:files.pythonhosted.orgpackagesa10826f69d1e9264e8107253018de9fc6b96f9219817d01c5f021e927384a8d1xlsxwriter-3.2.2.tar.gz"
    sha256 "befc7f92578a85fed261639fb6cde1fd51b79c5e854040847dde59d4317077dc"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagesfc4d8a8f57caccce49573e567744926f88c6ab3ca0b47a257806d1cf88584c5fyarl-1.19.0.tar.gz"
    sha256 "01e02bb80ae0dbed44273c304095295106e1d9470460e773268a27d11e594892"
  end

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_PLAYWRIGHT"] = resource("playwright").version
    virtualenv_install_with_resources
    bin.install_symlink libexec"bintheHarvester" => "theharvester"
  end

  test do
    output = shell_output("#{bin}theharvester -d brew.sh --limit 1 --source urlscan 2>&1")
    assert_match "docs.brew.sh", output
    assert_match "formulae.brew.sh", output
  end
end