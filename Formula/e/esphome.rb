class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32ESP8266 super easy"
  homepage "https:github.comesphomeesphome"
  url "https:files.pythonhosted.orgpackages318f549a22adf7121a7cc4bd6458df1da7388bc0d39fe926c833bb24ef191276esphome-2025.2.0.tar.gz"
  sha256 "17a74b524977d8919424cb6b6b305a5ad06b73658379cc7561f10aa59cde117c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "80613cf0f96d48a4637c550458f7232d53c70ea66b5613e00790fd0565022643"
    sha256 cellar: :any,                 arm64_sonoma:  "70e109fb7fce5ffb6539d836fe3c2dce93503a2c567fde82285aaabbabf04a5e"
    sha256 cellar: :any,                 arm64_ventura: "935f347f20d6f7e1d2ecdb3e5d7d75af3d90e39fd3e7934169db1f4de1b5f3b8"
    sha256 cellar: :any,                 sonoma:        "b5ceb2388e5b14099d9b7558a76ecb9da6e738dd619acad42703d0ff1a0544f4"
    sha256 cellar: :any,                 ventura:       "b993caac3365fb5d2ae2a9efa14472db1bda5898101798be2ccd93d125e8576b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dad6d4b368cab687a5d19caf27b171217e0e82587adce5435da246e8a6846c3"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  resource "aioesphomeapi" do
    url "https:files.pythonhosted.orgpackages815daf87d02e7ee8f6b5d34b07e3ea533bba43c2653954cd25e749fa09782228aioesphomeapi-29.1.0.tar.gz"
    sha256 "d4ba93e0fecf3efb240c3cabbf3dac8bee720b7db718b3bc16c29dd6bf165a5d"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages0807508f9ebba367fc3370162e53a3cfd12f5652ad79f0e0bfdf9f9847c6f159aiohappyeyeballs-2.4.6.tar.gz"
    sha256 "9b05052f9042985d32ecbe4b59a77ae19c006a78f1344d7fdad69d28ded3d0b0"
  end

  resource "ajsonrpc" do
    url "https:files.pythonhosted.orgpackagesda5c95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesa373199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cdeanyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages0cbe6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597argcomplete-3.5.3.tar.gz"
    sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  end

  resource "async-interrupt" do
    url "https:files.pythonhosted.orgpackages6e1596fb85b0f1a87d8feae8069351d32fe0bfa196f5b4aa0cf9cad191781d14async_interrupt-1.2.1.tar.gz"
    sha256 "52b8cbf763d8328c79946b1c9b4c34108370e9022cf285ad0c6c53042dabc82f"
  end

  resource "bitarray" do
    url "https:files.pythonhosted.orgpackages8562dcfac53d22ef7e904ed10a8e710a36391d2d6753c34c869b51bfc5e4ad54bitarray-3.0.0.tar.gz"
    sha256 "a2083dc20f0d828a7cdf7a16b20dae56aab0f43dc4f347a3b3039f6577992b03"
  end

  resource "bitstring" do
    url "https:files.pythonhosted.orgpackages0d4352859178f337661e2d496262f9061799d99644012b7b02ab5d7c491c21fdbitstring-4.3.0.tar.gz"
    sha256 "81800bc4e00b6508716adbae648e741256355c8dfd19541f76482fb89bee0313"
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
    url "https:files.pythonhosted.orgpackages5ed0ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051becdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
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
    url "https:files.pythonhosted.orgpackages1b8bf0d1e75879dee053874a4f955ed1e9ad97275485f51cb4bc2cb4e9b24479esptool-4.7.0.tar.gz"
    sha256 "01454e69e1ef3601215db83ff2cb1fc79ece67d24b0e5d43d451b410447c4893"
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
    url "https:files.pythonhosted.orgpackagesf7d1e0a911544ca9993e0f17ce6d3cc0932752356c1b0a834397f28e63479344protobuf-5.29.3.tar.gz"
    sha256 "5da0f41edaf117bde316404bad1a486cb4ededf8e4a54891296f648e8e076620"
  end

  resource "puremagic" do
    url "https:files.pythonhosted.orgpackagesd5cedc3a664654f1abed89d4e8a95ac3af02a2a0449c776ccea5ef9f48bde267puremagic-1.27.tar.gz"
    sha256 "7cb316f40912f56f34149f8ebdd77a91d099212d2ed936feb2feacfc7cbce2c1"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages88560f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages8b1a3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
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
    url "https:files.pythonhosted.orgpackagesbda2ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  resource "tzdata" do
    url "https:files.pythonhosted.orgpackages430ffa4723f22942480be4ca9527bbde8d43f6c3f2fe8412f00e7f5f6746bc8btzdata-2025.1.tar.gz"
    sha256 "24894909e88cdb28bd1636c6887801df64cb485bd593f2fd83ef29075a81d694"
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
    url "https:files.pythonhosted.orgpackagese8b496ab70984550e305fc85094d15b7b5317cbefdbcd5078659ffe5639d83eczeroconf-0.145.1.tar.gz"
    sha256 "3acb6146595597cfe6e314f8a4d530e659fcd9f9028cc9603a00518c98e57dd2"
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