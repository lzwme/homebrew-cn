class Locust < Formula
  include Language::Python::Virtualenv

  desc "Scalable user load testing tool written in Python"
  homepage "https://locust.io/"
  url "https://files.pythonhosted.org/packages/3e/ca/d09b4ffa73b5fee13dd6531ea255242b725391650e3abed6656117bcd5f2/locust-2.31.6.tar.gz"
  sha256 "03b6da0491d6a0b905692d9ac128d9deec403f40dc605c481a90dbab5126318c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9033c9c5f1cbc4bf7113ab8f25cabd9ad550278eb7d7973838aa8347452e8bbc"
    sha256 cellar: :any,                 arm64_sonoma:  "5bd02100d57f8bd558e255cd32e11cff00c0a42d67651830ed0a87b48ebf4f2e"
    sha256 cellar: :any,                 arm64_ventura: "108b0f63c0e04a37a494266048be6e9a4eb2a123bd2f52d5770d10e32c0cf0d4"
    sha256 cellar: :any,                 sonoma:        "f0ed5761e5cf909627a8935ac96047bea2d63526be1612195daa0fc9dc2a8806"
    sha256 cellar: :any,                 ventura:       "d46dcf24b7d1db195a56131002aa139edf1c894406f0efa5c43095c54bbde4a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6937a9699bcb4c9fc64d1960b401d01ee41e7b629a31d712c61f637e1e4071e0"
  end

  depends_on "cmake" => :build # for pyzmq
  depends_on "ninja" => :build # for pyzmq
  depends_on "certifi"
  depends_on "python@3.12"
  depends_on "zeromq"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1e/57/a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abcc/blinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/41/e1/d104c83026f8d35dfd2c261df7d64738341067526406b40190bc063e829a/flask-3.0.3.tar.gz"
    sha256 "ceb27b0af3823ea2737928a4d99d125a06175b8512c445cbd9a9ce200ef76842"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/4f/d0/d9e52b154e603b0faccc0b7c2ad36a764d8755ef4036acbf1582a67fb86b/flask_cors-5.0.0.tar.gz"
    sha256 "5aadb4b950c4e93745034594d9f3ea6591f734bb3662e16e255ffbf5e89c88ef"
  end

  resource "flask-login" do
    url "https://files.pythonhosted.org/packages/c3/6e/2f4e13e373bb49e68c02c51ceadd22d172715a06716f9299d9df01b6ddb2/Flask-Login-0.6.3.tar.gz"
    sha256 "5e23d14a607ef12806c699590b89d0f0e0d67baeec599d75947bf9c147330333"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/27/24/a3a7b713acfcf1177207f49ec25c665123f8972f42bee641bcc9f32961f4/gevent-24.2.1.tar.gz"
    sha256 "432fc76f680acf7cf188c2ee0f5d3ab73b63c1f03114c7cd8a34cebbe5aa2056"
  end

  resource "geventhttpclient" do
    url "https://files.pythonhosted.org/packages/8c/14/d4eddae757de44985718a9e38d9e6f2a923d764ed97d0f1cbc1a8aa2b0ef/geventhttpclient-2.3.1.tar.gz"
    sha256 "b40ddac8517c456818942c7812f555f84702105c82783238c9fcb8dc12675185"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/65/1b/3d91623c3eff61c11799e7f3d6c01f6bfa9bd2d1f0181116fd0b9b108a40/greenlet-3.1.0.tar.gz"
    sha256 "b395121e9bbe8d02a750886f108d540abe66075e61e22f7353d9acb0b81be0f0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/00/6f/93e724eafe34e860d15d37a4f72a1511dd37c43a76a8671b22a15029d545/idna-3.9.tar.gz"
    sha256 "e5c5dafde284f26e9e0f28f6ea2d6400abd5ca099864a67f576f3981c6476124"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/fd/05/bed626b9f7bb2322cdbbf7b4bd8f54b1b617b0d2ab2d3547d6e39428a48e/pyzmq-26.2.0.tar.gz"
    sha256 "070672c258581c8e4f640b5159297580a9974b026043bd4ab0470be9ed324f1f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/3e/2c/f0a538a2f91ce633a78daaeb34cbfb93a54bd2132a6de1f6cec028eee6ef/setuptools-74.1.2.tar.gz"
    sha256 "95b40ed940a1c67eb70fc099094bd6e99c6ee7c23aa2306f4d2697ba7916f9c6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/0f/e2/6dbcaab07560909ff8f654d3a2e5a60552d937c909455211b1b36d7101dc/werkzeug-3.0.4.tar.gz"
    sha256 "34f2371506b250df4d4f84bfe7b0921e4762525762bbd936614909fe25cd7306"
  end

  resource "zope-event" do
    url "https://files.pythonhosted.org/packages/46/c2/427f1867bb96555d1d34342f1dd97f8c420966ab564d58d18469a1db8736/zope.event-5.0.tar.gz"
    sha256 "bac440d8d9891b4068e2b5a2c5e2c9765a9df762944bda6955f96bb9b91e67cd"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/c8/83/7de03efae7fc9a4ec64301d86e29a324f32fe395022e3a5b1a79e376668e/zope.interface-7.0.3.tar.gz"
    sha256 "cd2690d4b08ec9eaf47a85914fe513062b20da78d10d6d789a792c0b20307fb1"
  end

  def install
    # skip frontend build
    ENV["SKIP_PRE_BUILD"] = "true"

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