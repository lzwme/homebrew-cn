class Kaskade < Formula
  include Language::Python::Virtualenv

  desc "TUI for Kafka"
  homepage "https:github.comsauljabinkaskade"
  url "https:files.pythonhosted.orgpackagesbbde32612086137119208038f7b978def5ac4f19669614fd89f2b1489d3c10b6kaskade-2.1.6.tar.gz"
  sha256 "2a8015b4c6b3c3a121ba73c3ffd87af48e687c5d812de6d257239f12090a1235"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e958d67c3c78ac84478cdc8c7a52b5b64587fdbc4401dd43ac8911612cebb49a"
    sha256 cellar: :any,                 arm64_ventura:  "cb5d158786b377b1556aba54c1b94d9418b2645fdc77117e25afc45e5be73529"
    sha256 cellar: :any,                 arm64_monterey: "654f49e92cfb3fb746aa29c22b16a72a5dd4e726d5a979d8c23a59e3793e07df"
    sha256 cellar: :any,                 sonoma:         "97f6198d30c0993463ca66509928a41f5ded4fd409e3692e71cb1e9f15b49795"
    sha256 cellar: :any,                 ventura:        "2a6242da2f701f112778d29edf7efd14d36c4ce6eeb76e7186a4512e44c0478c"
    sha256 cellar: :any,                 monterey:       "8551c854dc0e35261bfeb785cf742d8bd52c9b29e936d03d91e83f287e2b4fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f5e1a9282d75d8bb261cd74ac5cd279fcdfe72cbf3045a566a07a144041b712"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "librdkafka"
  depends_on "python@3.12"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "avro" do
    url "https:files.pythonhosted.orgpackages585b41d2dab437adbad4077acba55b05064c5eb0aea8e77145a0379564d32950avro-1.11.3.tar.gz"
    sha256 "3393bb5139f9cf0791d205756ce1e39a5b58586af5b153d6a3b5a199610e9d17"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "confluent-kafka" do
    url "https:files.pythonhosted.orgpackages94512e8f4048edbcde0346047dcd5228985ddcd0ef4d518f878321c07cc1b39cconfluent-kafka-2.5.0.tar.gz"
    sha256 "551cabaade717bb56ec13eb860ce439bedbcf1c97f4a4aa26957572ed1bfa74f"
  end

  resource "fastavro" do
    url "https:files.pythonhosted.orgpackagesc88379f4a4f83a0bb067777ed7fe085b167604da2277ddd8d922b9b11bc3a1dffastavro-1.9.5.tar.gz"
    sha256 "6419ebf45f88132a9945c51fe555d4f10bb97c236288ed01894f957c6f914553"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
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
    url "https:files.pythonhosted.orgpackages006c79c52651b22b64dba5c7bbabd7a294cc410bfb2353250dc8ade44d7d8ad8mdit_py_plugins-0.4.1.tar.gz"
    sha256 "834b8ac23d1cd60cec703646ffd22ae97b7955a6d596eb1d304be1e251ae499c"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages71a5d61e4263e62e6db1990c120d682870e5c50a30fb6b26119a214c7a014847protobuf-5.27.2.tar.gz"
    sha256 "f3ecdef226b9af856075f28227ff2c90ce3a594d092c39bee5513573f25e2714"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyrsistent" do
    url "https:files.pythonhosted.orgpackagesce3a5031723c09068e9c8c2f0bc25c3a9245f2b1d1aea8396c787a408f2b95capyrsistent-0.20.0.tar.gz"
    sha256 "4c48f78f62ab596c679086084d0dd13254ae4f3d6c72a83ffdf5ebdef8f265a4"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages36a283c3e2024cefb9a83d832e8835f9db0737a7a2b04ddfdd241c650b703db0rpds_py-0.19.0.tar.gz"
    sha256 "4fdc9afadbeb393b4bbbad75481e0ea78e4469f2e1d713a90811700830b553a9"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages2340100a105ab455be14cc5b96e2ecb0196ba28c506dcfd0c497a796db3c90c5textual-0.72.0.tar.gz"
    sha256 "14174ce8d49016a85aa6c0669d0881b5419e98cf46d429f263314295409ed262"
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
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    r, _w, pid = PTY.spawn("#{bin}kaskade admin -b localhost:9092")
    assert_match "all:     escape describe: enter", r.readline

    assert_match version.to_s, shell_output("#{bin}kaskade --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end