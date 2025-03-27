class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32ESP8266 super easy"
  homepage "https:github.comesphomeesphome"
  url "https:files.pythonhosted.orgpackages6a99fe9ccc78710975a8b694a00e27ef642ae6f1db2b12ae9053f7fb75a7c5b4esphome-2025.3.2.tar.gz"
  sha256 "a199d642438fd9edda72b845ff87955e99e6535d83a51a69997efc92eeb259fc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1e7912e43d7398ae80c06cd2ca27abb72bbc28eb8fffa0928c19874957f8e03"
    sha256 cellar: :any,                 arm64_sonoma:  "34bdeccc453a112802c14efb241188b7e55c5ea6c26fde8e95fda1975db74a76"
    sha256 cellar: :any,                 arm64_ventura: "a2ef7b62ab9417f8ea2e85e7f43ba6e1d190fd60db93d9a63a5739a3c73cc74e"
    sha256 cellar: :any,                 sonoma:        "8527c7acba502404fe416bc7ccf65ff41af3cde49919bd85cdd20813e8cb57df"
    sha256 cellar: :any,                 ventura:       "b0ccfef43d8287c3ef5e15c2b9a6ea43746e2c1734c26669452e9b9e5adfa145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f4c015567a75684b05acf5b946317d1011ef8bfddc5635e4c92fa840c49a60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef97d7a8df21320581469565d4aa44f5d30ae6f5d12ba9552f0ac21c355e1d25"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  resource "aioesphomeapi" do
    url "https:files.pythonhosted.orgpackages483b4ea67fa33e05a26815e4139b5cacf3eac51bf364641172875c6221d8079aaioesphomeapi-29.6.0.tar.gz"
    sha256 "5e5fb17ad505508f25f4a64134b14641d14adebc4066595a19184c4382310288"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "ajsonrpc" do
    url "https:files.pythonhosted.orgpackagesda5c95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages0a35aacd2207c79d95e4ace44292feedff8fccfd8b48135f42d84893c24cc39bargcomplete-3.6.1.tar.gz"
    sha256 "927531c2fbaa004979f18c2316f6ffadcfc5cc2de15ae2624dfe65deaf60e14f"
  end

  resource "async-interrupt" do
    url "https:files.pythonhosted.orgpackages5679732a581e3ceb09f938d33ad8ab3419856181d95bb621aa2441a10f281e10async_interrupt-1.2.2.tar.gz"
    sha256 "be4331a029b8625777905376a6dc1370984c8c810f30b79703f3ee039d262bf7"
  end

  resource "bitarray" do
    url "https:files.pythonhosted.orgpackages70e2b80354798b87e4b6918ba0ad71d30da3e14c83ea38cb4a4e609d49501dd3bitarray-3.2.0.tar.gz"
    sha256 "f766d1c6a5cbb1f87cb8ce0ff46cefda681cc2f9bef971908f914b2862409922"
  end

  resource "bitstring" do
    url "https:files.pythonhosted.orgpackages15a8a80c890db75d5bdd5314b5de02c4144c7de94fd0cefcae51acaeb14c6a3fbitstring-4.3.1.tar.gz"
    sha256 "a08bc09d3857216d4c0f412a1611056f1cc2b64fd254fb1e8a0afba7cfa1a95a"
  end

  resource "bottle" do
    url "https:files.pythonhosted.orgpackages1bfb97839b95c2a2ea1ca91877a846988f90f4ca16ee42c0bb79e079171c0c06bottle-0.13.2.tar.gz"
    sha256 "e53803b9d298c7d343d00ba7d27b0059415f04b9f6f40b8d58b5bf914ba9d348"
  end

  resource "chacha20poly1305-reuseable" do
    url "https:files.pythonhosted.orgpackagesc1ff6ca12ab8f4d804cfe423e67d7e5de168130b106a0cb749a1043943c23b6bchacha20poly1305_reuseable-0.13.2.tar.gz"
    sha256 "dd8be876e25dfc51909eb35602b77a76e0d01a364584756ab3fa848e2407e4ec"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackagesc01f924e3caae75f471eae4b26bd13b698f6af2c44279f67af317439c2f4c46aecdsa-0.19.1.tar.gz"
    sha256 "478cba7b62555866fcb3bb3fe985e06decbdb68ef55713c4e5ab98c57d508e61"
  end

  resource "esphome-dashboard" do
    url "https:files.pythonhosted.orgpackagesf6eeb86dd92826d37bf48f3d1b92a867e4adca3b44bb045651e2209ecb6e4737esphome_dashboard-20250212.0.tar.gz"
    sha256 "921dec0279187f43a32f80a6f6e603b1c3d98c3cc0be7b8d0f5b761eea7440ee"
  end

  resource "esphome-glyphsets" do
    url "https:files.pythonhosted.orgpackagesaba77c4912a225d800eb1507a837d8a4ee04c3efccf4f9c3d37946aad0ee1186esphome_glyphsets-0.1.0.tar.gz"
    sha256 "81c287057dee8df39af0d467a6a94ea9d827e72b94c461782e6a731cec5b7e24"
  end

  resource "esptool" do
    url "https:files.pythonhosted.orgpackages5c6b3ce9bb7f36bdef3d6ae71646a1d3b7d59826a478f3ed8a783a93a2f8f537esptool-4.8.1.tar.gz"
    sha256 "dc4ef26b659e1a8dcb019147c0ea6d94980b34de99fbe09121c7941c8b254531"
  end

  resource "freetype-py" do
    url "https:files.pythonhosted.orgpackagesd09c61ba17f846b922c2d6d101cc886b0e8fb597c109cedfcb39b8c5d2304b54freetype-py-2.5.1.zip"
    sha256 "cfe2686a174d0dd3d71a9d8ee9bf6a2c23f5872385cf8ce9f24af83d076e2fbd"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "icmplib" do
    url "https:files.pythonhosted.orgpackages6d78ca07444be85ec718d4a7617f43fdb5b4eaae40bc15a04a5c888b64f3e35ficmplib-3.0.4.tar.gz"
    sha256 "57868f2cdb011418c0e1d5586b16d1fabd206569fe9652654c27b6b2d6a316de"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ifaddr" do
    url "https:files.pythonhosted.orgpackagese8acfb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "intelhex" do
    url "https:files.pythonhosted.orgpackages66371e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "kconfiglib" do
    url "https:files.pythonhosted.orgpackages868254537aeb187ade9b609af3d2988312350a7fab2ff2d3ec0230ae0410dc9ekconfiglib-13.7.1.tar.gz"
    sha256 "a2ee8fb06102442c45965b0596944f02c2a1517f092fa208ca307f3fd12a0a22"
  end

  resource "marshmallow" do
    url "https:files.pythonhosted.orgpackagesab5e5e53d26b42ab75491cda89b871dab9e97c840bf12c63ec58a1919710cd06marshmallow-3.26.1.tar.gz"
    sha256 "e6d8affb6cb61d39d26402096dc0aee12d5a26d490a121f118d2e81dc0719dc6"
  end

  resource "noiseprotocol" do
    url "https:files.pythonhosted.orgpackages7617fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "paho-mqtt" do
    url "https:files.pythonhosted.orgpackagesf8dd4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "platformio" do
    url "https:files.pythonhosted.orgpackages32a04b1d18da2668a37b28beff3ecdc934940516302565c31a4cd4e17661a285platformio-6.1.16.tar.gz"
    sha256 "79387b45ca7df9c0c51cae82b3b0a40ba78d11d87cea385db47e1033d781e959"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages55de8216061897a67b2ffe302fd51aaa76bbf613001f01cd96e2416a4955dd2bprotobuf-6.30.1.tar.gz"
    sha256 "535fb4e44d0236893d5cf1263a0f706f1160b689a7ab962e9da8a9ce4050b780"
  end

  resource "puremagic" do
    url "https:files.pythonhosted.orgpackagesd5cedc3a664654f1abed89d4e8a95ac3af02a2a0449c776ccea5ef9f48bde267puremagic-1.27.tar.gz"
    sha256 "7cb316f40912f56f34149f8ebdd77a91d099212d2ed936feb2feacfc7cbce2c1"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackagesb9ab33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071afpyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackagesbb22f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60fpyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pyserial" do
    url "https:files.pythonhosted.orgpackages1e7dae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "reedsolo" do
    url "https:files.pythonhosted.orgpackagesf761a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5ereedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https:files.pythonhosted.orgpackages020a62fbd5697f6174041f9b4e2e377b6f383f9189b77dbb7d73d24624caca1dstarlette-0.39.2.tar.gz"
    sha256 "caaa3b87ef8518ef913dac4f073dea44e85f73343ad2bdc17941931835b2a26a"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tornado" do
    url "https:files.pythonhosted.orgpackages5945a0daf161f7d6f36c3ea5fc0c2de619746cc3dd4c76402e9db545bd920f63tornado-6.4.2.tar.gz"
    sha256 "92bad5b4746e9879fd7bf1eb21dce4e3fc5128d71601f80005afa39237ad620b"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages95321a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "tzlocal" do
    url "https:files.pythonhosted.orgpackages04d3c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackages5a015e637e7aa9dd031be5376b9fb749ec20b86f5a5b6a49b87fabd374d5fa9fuvicorn-0.30.6.tar.gz"
    sha256 "4b15decdda1e72be08209e860a1e10e92439ad5b97cf44cc945fcbee66fc5788"
  end

  resource "voluptuous" do
    url "https:files.pythonhosted.orgpackagesa1ce0733e4d6f870a0e5f4dbb00766b36b71ee0d25f8de33d27fb662f29154b1voluptuous-0.14.2.tar.gz"
    sha256 "533e36175967a310f1b73170d091232bf881403e4ebe52a9b4ade8404d151f5d"
  end

  resource "wsproto" do
    url "https:files.pythonhosted.orgpackagesc94a44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5awsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "zeroconf" do
    url "https:files.pythonhosted.orgpackages436b5fa7a4c677376b549655d67f6902c80bde4b534405cdf2b5f0c50cc7bd8azeroconf-0.146.1.tar.gz"
    sha256 "c53c07d6df3698bd19dcc832a897181872ec47e98e7cd70cff6c1bb0aff0bbfd"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec"binregister-python-argcomplete", "esphome",
                                         shell_parameter_format: :arg)
  end

  test do
    (testpath"test.yaml").write <<~YAML
      esphome:
        name: test
      esp8266:
        board: d1
    YAML

    assert_includes shell_output("#{bin}esphome config #{testpath}test.yaml 2>&1"), "INFO Configuration is valid!"
    return if Hardware::CPU.arm?

    ENV.remove_macosxsdk if OS.mac?
    system bin"esphome", "compile", "test.yaml"
  end
end