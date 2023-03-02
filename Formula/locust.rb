class Locust < Formula
  include Language::Python::Virtualenv

  desc "Scalable user load testing tool written in Python"
  homepage "https://locust.io/"
  url "https://files.pythonhosted.org/packages/ec/aa/9f3a1629469f019fd5224b5f8ea2f15ce1d5f2ffac79fdeab07b748a7a8b/locust-2.15.0.tar.gz"
  sha256 "11deb7973cfe30a2703f7a93eda21eacafb4b1b4159924a0b5c1d0399d9ff21d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23e6b33f01beb48c391d5c0e283782afd1cd24a6d77fc6f2843c47fbf833c7e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d0299f1d741b62ffa4ef382ff63f041fcc5bc41ab945a79b28d37bedf513f8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39730960d20a71270190c7609482b6d0d52eef01877fde6bbc3e9f5df0e8d4a0"
    sha256 cellar: :any_skip_relocation, ventura:        "f0cb3f49499745ef5237928b2897f4e03e3777859694a1990a84a9081bf3495f"
    sha256 cellar: :any_skip_relocation, monterey:       "46db90d8428c77914a49dda00974b27374847bc6f00f6fe8409dc6aa7f51cc71"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9bfab21ff20b4aa90d82b7d848da3801dd41a25e8a455785dc80daff717031a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9997aa127997bb48470c36eb8b6b766bed0dc5050ade8fcb604e1710de91d625"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/e8/5c/ff9047989bd995b1098d14b03013f160225db2282925b517bb4a967752ee/Flask-2.2.3.tar.gz"
    sha256 "7eb373984bf1c770023fce9db164ed0c3353cd0b53f130f4693da0ca756a2e6d"
  end

  resource "Flask-BasicAuth" do
    url "https://files.pythonhosted.org/packages/16/18/9726cac3c7cb9e5a1ac4523b3e508128136b37aadb3462c857a19318900e/Flask-BasicAuth-0.2.0.tar.gz"
    sha256 "df5ebd489dc0914c224419da059d991eb72988a01cdd4b956d52932ce7d501ff"
  end

  resource "Flask-Cors" do
    url "https://files.pythonhosted.org/packages/cf/25/e3b2553d22ed542be807739556c69621ad2ab276ae8d5d2560f4ed20f652/Flask-Cors-3.0.10.tar.gz"
    sha256 "b60839393f3b84a0f3746f6cdca56c1ad7426aa738b70d6c61375857823181de"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/9f/4a/e9e57cb9495f0c7943b1d5965c4bdd0d78bc4a433a7c96ee034b16c01520/gevent-22.10.2.tar.gz"
    sha256 "1ca01da176ee37b3527a2702f7d40dbc9ffb8cfc7be5a03bfa4f9eec45e55c46"
  end

  resource "geventhttpclient" do
    url "https://files.pythonhosted.org/packages/bf/05/93c4e1e525c15890a6222833a31a1abb5df987d6d16e0dadb395796a19b5/geventhttpclient-2.0.8.tar.gz"
    sha256 "5f782c419643f74be4d0918c0d2b63956ef6ddc7a2127f07cbb8033a75ab366f"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/1e/1e/632e55a04d732c8184201238d911207682b119c35cecbb9a573a6c566731/greenlet-2.0.2.tar.gz"
    sha256 "e7c8dc13af7db097bed64a051d2dd49e9f0af495c26995c00a9ee842690d34c0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/cf/89/9dbc5bc589a06e94d493b551177a0ebbe70f08b5ebdd49dddf212df869ff/pyzmq-25.0.0.tar.gz"
    sha256 "f330a1a2c7f89fd4b0aa4dcb7bf50243bf1c8da9a2f1efc31daf57a2046b31f2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "roundrobin" do
    url "https://files.pythonhosted.org/packages/38/97/6508c09e3af7eaee96e7b66a7dc7bbdbe8e6b85b8d2bbbb89612cf621bad/roundrobin-0.0.4.tar.gz"
    sha256 "7e9d19a5bd6123d99993fb935fa86d25c88bb2096e493885f61737ed0f5e9abd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/02/3c/baaebf3235c87d61d6593467056d5a8fba7c75ac838b8d100a5e64eba7a0/Werkzeug-2.2.3.tar.gz"
    sha256 "2e1ccc9417d4da358b9de6f174e3ac094391ea1d4fbef2d667865d819dfd0afe"
  end

  resource "zope.event" do
    url "https://files.pythonhosted.org/packages/42/49/ba8610674cad200da2f9c87b5f52fdcf18b02dd743a8a1e90726803cc42f/zope.event-4.6.tar.gz"
    sha256 "81d98813046fc86cc4136e3698fee628a3282f9c320db18658c21749235fce80"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/38/6f/fbfb7dde38be7e5644bb342c4c7cdc444cd5e2ffbd70d091263b3858a8cb/zope.interface-5.5.2.tar.gz"
    sha256 "bfee1f3ff62143819499e348f5b8a7f3aa0259f9aca5e0ddae7391d059dce671"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"locustfile.py").write <<~EOS
      from locust import HttpUser, task

      class HelloWorldUser(HttpUser):
          @task
          def hello_world(self):
              self.client.get("/headers")
              self.client.get("/ip")
    EOS

    ENV["LOCUST_LOCUSTFILE"] = testpath/"locustfile.py"
    ENV["LOCUST_HOST"] = "http://httpbin.org"
    ENV["LOCUST_USERS"] = "2"

    system bin/"locust", "--headless", "--run-time", "10s"
  end
end