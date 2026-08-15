class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https://uvicorn.dev/"
  url "https://files.pythonhosted.org/packages/2e/28/64ca011edf31c715b4fad359c587ea52391aaffa125065695590241ff617/uvicorn-0.52.3.tar.gz"
  sha256 "18857b9e6579300be55c91c0a1cfd37d9a2cf0cabea33b88275f199eb73b8b58"
  license "BSD-3-Clause"
  head "https://github.com/Kludex/uvicorn.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e8681059776088b3051741215c6b8400f6a2aaa4da55c94c59a8a03465b723ce"
    sha256 cellar: :any, arm64_sequoia: "a92bb81e3da87376ccf97edbf8659a849cd9b673b7d7c3e9ce0288aa7fd802df"
    sha256 cellar: :any, arm64_sonoma:  "fb3900bbb3657c6b1873c727ec6a50e6756dc30bb02982ad6cb98cb7d688ad6a"
    sha256 cellar: :any, sonoma:        "f82042e2e5be4b63595e63c70e92bb3161e17898e20d53f544e9e592edc3732a"
    sha256 cellar: :any, arm64_linux:   "28cca3b563a8b192a86a0cef635153c472f82c4d2441f300c343358a7609aa36"
    sha256 cellar: :any, x86_64_linux:  "3938216f57536df765f78c1b21488c67b532ce114e9c33deeadaed9f3c9835bf"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages package_name: "uvicorn[standard]"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/43/e5/d471fcb0e14523fe1c3f4ba58ca52480e7bd70ad7109a3846bc75892f7fb/httptools-0.8.0.tar.gz"
    sha256 "6b2a32f18d97e16e90827d7a819ffa8dbd8cc245fc4e1fa9d1095b54ef4bd999"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
    sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/f7/96/e01084f83a64bcb3a27994bd0cb0db68ff29d9c6707fae37ec19b18ba990/websockets-17.0.1.tar.gz"
    sha256 "5baa9bc0dfbae8c507e51c8cf1b6d4628086f7a87bbd3a9952bd5f035451f1cc"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"uvicorn", shell_parameter_format: :click)
  end

  test do
    (testpath/"example.py").write <<~PYTHON
      async def app(scope, receive, send):
          assert scope['type'] == 'http'

          await send({
              'type': 'http.response.start',
              'status': 200,
              'headers': [
                  (b'content-type', b'text/plain'),
              ],
          })
          await send({
              'type': 'http.response.body',
              'body': b'Hello, Homebrew!',
          })
    PYTHON

    port = free_port
    pid = spawn bin/"uvicorn", "--port=#{port}", "example:app"

    assert_match "Hello, Homebrew!", shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end