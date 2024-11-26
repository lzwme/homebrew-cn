class Kaskade < Formula
  include Language::Python::Virtualenv

  desc "TUI for Kafka"
  homepage "https:github.comsauljabinkaskade"
  url "https:files.pythonhosted.orgpackages83c6a45beb34205a75c741af46a85e97c2f937be62f80544709548935638a167kaskade-3.0.0.tar.gz"
  sha256 "145743c7bfa96a9c773fe5c972f6c384351c5143248b22bdca5b18de271ec393"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4af21e945966de1449cfe71539da94e559b7de1da39b376500fd3f61240e6cb2"
    sha256 cellar: :any,                 arm64_sonoma:  "23d08912126580368b032741776c4567e8348abfd874e7cae2152f06475a3217"
    sha256 cellar: :any,                 arm64_ventura: "c3e4532e7927bbc9d8b923ff2f4a44effe5038dd3bbfa010b734a466af9b513a"
    sha256 cellar: :any,                 sonoma:        "557e32247dd975d5756a8e22632901a648e8fa4add5b5230c64c64f460bee574"
    sha256 cellar: :any,                 ventura:       "690d33cf860118068757acddcce23ba479da39b58661b21d7bdab7067ac5939a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d46fb1a75958d40bfe2926cfe20eaa30d4b97b0921264e1a9512ce5b2cfc5474"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "librdkafka"
  depends_on "python@3.13"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "avro" do
    url "https:files.pythonhosted.orgpackagese67348668732bbc8ae1e79b237f84e761204c8dd266c5e16e7601000aba471d3avro-1.12.0.tar.gz"
    sha256 "cad9c53b23ceed699c7af6bddced42e2c572fd6b408c257a7d4fc4e8cf2e2d6b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https:files.pythonhosted.orgpackages1389928e6886ba33f5847692430d003dc33f81a6e595d25f9935d6185ea073d3confluent_kafka-2.6.1.tar.gz"
    sha256 "71fdab0f65ccdb00eff0f14ccde65723ebbd20392723f8c1e87e5d8ab29e50cf"
  end

  resource "fastavro" do
    url "https:files.pythonhosted.orgpackages115672dc3fa6985c7f27b392cd3991c466eb61208f3c6cb7fc2f12e6bfc6f774fastavro-1.9.7.tar.gz"
    sha256 "13e11c6cb28626da85290933027cd419ce3f9ab8e45410ef24ce6b89d20a1f6c"
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
    url "https:files.pythonhosted.orgpackages746ee69eb906fddcb38f8530a12f4b410699972ab7ced4e21524ece9d546ac27protobuf-5.28.3.tar.gz"
    sha256 "64badbc49180a5e401f373f9ce7ab1d18b63f7dd4a9cdc43c92b9f0b481cef7b"
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
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages2380afdf96daf9b27d61483ef05b38f282121db0e38f5fd4e89f40f5c86c2a4frpds_py-0.21.0.tar.gz"
    sha256 "ed6378c9d66d0de903763e7706383d60c33829581f0adff47b6535f1802fa6db"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackages616ae643a0d32dc964f831172ff84d4d1b0e3c6675954e74f81c201713c58d69textual-0.87.1.tar.gz"
    sha256 "daf4e248ba3d890831ff2617099535eb835863a2e3609c8ce00af0f6d55ed123"
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
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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