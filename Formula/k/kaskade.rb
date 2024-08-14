class Kaskade < Formula
  include Language::Python::Virtualenv

  desc "TUI for Kafka"
  homepage "https:github.comsauljabinkaskade"
  url "https:files.pythonhosted.orgpackages8fed33677f4c2199fd6dfa7206304de37b971342345a4713a96717629ed05760kaskade-2.3.4.tar.gz"
  sha256 "f2df4a3f5f6e82adb1f708a1ad0dac4b080a23b36458b1bc972b637f6d88f611"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9c408b4bd7ae294cfab6b0b4e56d7f15f27e08a78b5ab25eeec6e61429959c36"
    sha256 cellar: :any,                 arm64_ventura:  "127b849262d980814c421a642ca9578de4d2d8906ea5e5ef8588c9a546e7d781"
    sha256 cellar: :any,                 arm64_monterey: "0819eca9e2ba4ed2821ff0663ccd1a10e23cc37303dea3690f2dfaa2c6a3a320"
    sha256 cellar: :any,                 sonoma:         "5405ddab1aef99def5c478ec32304e92bd301a4b1a5f1716930794179c67ff87"
    sha256 cellar: :any,                 ventura:        "026ec5f259f5f569145b8a5df11e82d075898aeea9dcfbd4650182a55ccea3b2"
    sha256 cellar: :any,                 monterey:       "3fd1e4f7b3ec580ba1ba4ab760fed989993fe1709c3a51b11d764c90483e99cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62332d9e7e040a0206243f24cbe7924b4286c7e759ada19497cd38cba7aeea39"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "librdkafka"
  depends_on "python@3.12"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "avro" do
    url "https:files.pythonhosted.orgpackagese67348668732bbc8ae1e79b237f84e761204c8dd266c5e16e7601000aba471d3avro-1.12.0.tar.gz"
    sha256 "cad9c53b23ceed699c7af6bddced42e2c572fd6b408c257a7d4fc4e8cf2e2d6b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cloup" do
    url "https:files.pythonhosted.orgpackagescf71608e4546208e5a421ef00b484f582e58ce0f17da05459b915c8ba22dfb78cloup-3.0.5.tar.gz"
    sha256 "c92b261c7bb7e13004930f3fb4b3edad8de2d1f12994dcddbe05bc21990443c5"
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
    url "https:files.pythonhosted.orgpackages1b610671db2ab2aee7c92d6c1b617c39b30a4cd973950118da56d77e7f397a9dprotobuf-5.27.3.tar.gz"
    sha256 "82460903e640f2b7e34ee81a947fdaad89de796d324bcbc38ff5430bcdead82c"
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
    url "https:files.pythonhosted.orgpackages5564b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29arpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackagesd0ea9139a6156c6dc2f40592fc50dceb8c57c5e53d235c20c2c41fe3cc363b1ftextual-0.76.0.tar.gz"
    sha256 "b12e8879d591090c0901b5cb8121d086e28e677353b368292d3865ec99b83b70"
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
    assert_match "\e[?1049h\e[?1000h\e[?1003h\e[?1015h\e[?1006h\e[?25l", r.readline

    assert_match version.to_s, shell_output("#{bin}kaskade --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end