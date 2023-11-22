class Locust < Formula
  include Language::Python::Virtualenv

  desc "Scalable user load testing tool written in Python"
  homepage "https://locust.io/"
  url "https://files.pythonhosted.org/packages/b6/32/a280f0bc15bfb6ce40c8d63d6896f81d9b7ee5f8600bd1a5d079013ad5f1/locust-2.19.0.tar.gz"
  sha256 "091bb8ee321a9a63e160d0f6de0a0819c62f18378e44986bc5d446d017875aa6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75c4a573d0669a4f6f611e97903027ac76c63df0d05300a9f2b4b42e4042547d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe93f9e40c8df9cbc09f361d121a3e68478f85103854df628384c75e134949b8"
    sha256 cellar: :any_skip_relocation, ventura:        "599abc396fe31b712c6dd3ad888f7eac3bacce1d0efaa3341b33a317feb62375"
    sha256 cellar: :any_skip_relocation, monterey:       "35aa8695cf5b0843d571f54df080be19386ab26f208e88816c795b7aeee71a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f9c11833144f7293a2260ede7ab29625f3c76b7e10f346b9fe1589c6373feb1"
  end

  depends_on "python-brotli"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-markupsafe"
  depends_on "python-psutil"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/a1/13/6df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9e/blinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/d8/09/c1a7354d3925a3c6c8cfdebf4245bae67d633ffda1ba415add06ffc839c5/flask-3.0.0.tar.gz"
    sha256 "cfadcdb638b609361d29ec22360d6070a77d7463dcb3ab08d2c2f2f168845f58"
  end

  resource "flask-basicauth" do
    url "https://files.pythonhosted.org/packages/16/18/9726cac3c7cb9e5a1ac4523b3e508128136b37aadb3462c857a19318900e/Flask-BasicAuth-0.2.0.tar.gz"
    sha256 "df5ebd489dc0914c224419da059d991eb72988a01cdd4b956d52932ce7d501ff"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/c8/b0/bd7130837a921497520f62023c7ba754e441dcedf959a43e6d1fd86e5451/Flask-Cors-4.0.0.tar.gz"
    sha256 "f268522fcb2f73e2ecdde1ef45e2fd5c71cc48fe03cffb4b441c6d1b40684eb0"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/8e/ce/d2b9a376ee010f6d548bf1b6b6eddc372a175e6e100896e607c57e37f7cf/gevent-23.9.1.tar.gz"
    sha256 "72c002235390d46f94938a96920d8856d4ffd9ddf62a303a0d7c118894097e34"
  end

  resource "geventhttpclient" do
    url "https://files.pythonhosted.org/packages/f2/13/44907f010f2db2156480b0ef83cb3fecb09da0b3e9ab8128716a162c635e/geventhttpclient-2.0.11.tar.gz"
    sha256 "549d0f3af08420b9ad2beeda211153c7605b5ba409b228db7f1b81c8bfbec6b4"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/54/df/718c9b3e90edba70fa919bb3aaa5c3c8dabf3a8252ad1e93d33c348e5ca4/greenlet-3.0.1.tar.gz"
    sha256 "816bd9488a94cba78d93e1abb58000e8266fa9cc2aa9ccdd6eb0696acb24005b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/3f/7c/69d31a75a3fe9bbab349de7935badac61396f22baf4ab53179a8d940d58e/pyzmq-25.1.1.tar.gz"
    sha256 "259c22485b71abacdfa8bf79720cd7bcf4b9d128b30ea554f01ae71fdbfdaa23"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "roundrobin" do
    url "https://files.pythonhosted.org/packages/38/97/6508c09e3af7eaee96e7b66a7dc7bbdbe8e6b85b8d2bbbb89612cf621bad/roundrobin-0.0.4.tar.gz"
    sha256 "7e9d19a5bd6123d99993fb935fa86d25c88bb2096e493885f61737ed0f5e9abd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0d/cc/ff1904eb5eb4b455e442834dabf9427331ac0fa02853bf83db817a7dd53d/werkzeug-3.0.1.tar.gz"
    sha256 "507e811ecea72b18a404947aded4b3390e1db8f826b494d76550ef45bb3b1dcc"
  end

  resource "zope-event" do
    url "https://files.pythonhosted.org/packages/46/c2/427f1867bb96555d1d34342f1dd97f8c420966ab564d58d18469a1db8736/zope.event-5.0.tar.gz"
    sha256 "bac440d8d9891b4068e2b5a2c5e2c9765a9df762944bda6955f96bb9b91e67cd"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/87/03/6b85c1df2dca1b9acca38b423d1e226d8ffdf30ebd78bcb398c511de8b54/zope.interface-6.1.tar.gz"
    sha256 "2fdc7ccbd6eb6b7df5353012fbed6c3c5d04ceaca0038f75e601060e95345309"
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

    system bin/"locust", "--headless", "--run-time", "3s"
  end
end