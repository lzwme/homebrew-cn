class Kaskade < Formula
  include Language::Python::Virtualenv

  desc "TUI for Kafka"
  homepage "https:github.comsauljabinkaskade"
  url "https:files.pythonhosted.orgpackageseff026c6901ad2dc37333f655ed454c4a8f37616f5b2ef0a26a29b59d0a7a19bkaskade-4.0.3.tar.gz"
  sha256 "1a333b4eaa98b000cdb7cb6ed5cec20215c81513160a0af81931888a7beae442"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "7c5d25b0b0fc2905abebf72d657ca1ea39b196c52f8ba62f770b6dc87be46a2a"
    sha256 cellar: :any,                 arm64_sonoma:  "c25c794c8fdb618cd5db3802d69a11589fd8ba8e7d540b9c496dbe7ca1630cbb"
    sha256 cellar: :any,                 arm64_ventura: "9e6cf9fbd557f26ecb4405a43f7a5b6ba5549aaa253a36f1bd0b5b32253dbb9d"
    sha256 cellar: :any,                 sonoma:        "40d8da8542b9042ce0bba79257a8527a3e15cb61c7b4008d819a5cd139ce75ff"
    sha256 cellar: :any,                 ventura:       "ed5323a6851e9fef87f243456e261dac79dcec152478f64ba4192e1c12b386d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b7115989c9104c9293b73f243eada0c22f520e537e2e7faf7dcc33168e301f5"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "librdkafka"
  depends_on "python@3.13"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesa373199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cdeanyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages48c86260f8ccc11f0917360fc0da435c5c9c7504e3db174d5a12a1494887b045attrs-24.3.0.tar.gz"
    sha256 "8f5c07333d543103541ba7be0e2ce16eeee8130cb0b3f9238ab904ce1e85baff"
  end

  resource "avro" do
    url "https:files.pythonhosted.orgpackagese67348668732bbc8ae1e79b237f84e761204c8dd266c5e16e7601000aba471d3avro-1.12.0.tar.gz"
    sha256 "cad9c53b23ceed699c7af6bddced42e2c572fd6b408c257a7d4fc4e8cf2e2d6b"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesc338a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "cloup" do
    url "https:files.pythonhosted.orgpackagescf71608e4546208e5a421ef00b484f582e58ce0f17da05459b915c8ba22dfb78cloup-3.0.5.tar.gz"
    sha256 "c92b261c7bb7e13004930f3fb4b3edad8de2d1f12994dcddbe05bc21990443c5"
  end

  resource "confluent-kafka" do
    url "https:files.pythonhosted.orgpackagesbda7a6bd180293fd9ac81f60bf7e9488ba133d5fdaa00aa94518900711c206c0confluent_kafka-2.8.0.tar.gz"
    sha256 "56c4aa8e9de6f6e8e3ecf86d396372e76631ec75b107cdb5248c7405ec7c5fa1"
  end

  resource "fastavro" do
    url "https:files.pythonhosted.orgpackagesf3677121d2221e998706cac00fa779ec44c1c943cb65e8a7ed1bd57d78d93f2cfastavro-1.10.0.tar.gz"
    sha256 "47bf41ac6d52cdfe4a3da88c75a802321321b37b663a900d12765101a5d6886f"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackagesffa78e9cccdb1c49870de6faea2a2764fa23f627dd290633103540209f03524cgoogleapis_common_protos-1.66.0.tar.gz"
    sha256 "c3e7b33d15fdca5374cc0a7346dd92ffa847425cc4ea941d970f13680052ec8c"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages6a41d7d0a89eb493922c37d343b607bc1b5da7f5be7e383740b4753ad8943e90httpcore-1.0.7.tar.gz"
    sha256 "8551cb62a169ec7162ac7be8d4817d561f60e08eaa485234898414bb5a8a0b4c"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages2aaebb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96alinkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdit-py-plugins" do
    url "https:files.pythonhosted.orgpackages1903a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fdmdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagesf7d1e0a911544ca9993e0f17ce6d3cc0932752356c1b0a834397f28e63479344protobuf-5.29.3.tar.gz"
    sha256 "5da0f41edaf117bde316404bad1a486cb4ededf8e4a54891296f648e8e076620"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyrsistent" do
    url "https:files.pythonhosted.orgpackagesce3a5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95capyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2732fd98246df7a0f309b58cae68b10b6b219ef2eb66747f00dfb34422687087referencing-0.36.1.tar.gz"
    sha256 "ca2e6492769e3602957e9b831b94211599d2aade9477f5d44110d2530cf9aade"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages0180cce854d0921ff2f0a9fa831ba3ad3c65cee3a46711addf39a2af52df2cfdrpds_py-0.22.3.tar.gz"
    sha256 "e32fee8ab45d3c2db6da19a5323bc3362237c8b653c70194414b892fd06a080d"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages1fb659b1de04bb4dca0f21ed7ba0b19309ed7f3f5de4396edf20cc2855e53085textual-1.0.0.tar.gz"
    sha256 "bec9fe63547c1c552569d1b75d309038b7d456c03f86dfa3706ddb099b151399"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages917a146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"
    virtualenv_install_with_resources
  end

  test do
    r, _w, pid = PTY.spawn("#{bin}kaskade admin -b localhost:9092")
    assert_match "\e[?1049h\e[?1000h\e[?1003h\e[?1015h\e[?1006h\e[?25l", r.readline

    assert_match version.to_s, shell_output("#{bin}kaskade --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end