class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https:www.uvicorn.org"
  url "https:files.pythonhosted.orgpackagescb81a083ae41716b00df56d45d4b5f6ca8e90fc233a62e6c04ab3ad3c476b6c4uvicorn-0.33.0.tar.gz"
  sha256 "3577119f82b7091cf4d3d4177bfda0bae4723ed92ab1439e8d779de880c9cc59"
  license "BSD-3-Clause"
  head "https:github.comencodeuvicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c59d46e26e2b04899095ec83085c42afd376e9c488eece067adcaf60fec33e4"
    sha256 cellar: :any,                 arm64_sonoma:  "629aaaf2eaa0962418db0090b0644741e0fc6e8e02171cd04a9238a6d33e06f4"
    sha256 cellar: :any,                 arm64_ventura: "3863d5fd7dd088bf5f5a79a540a6d3cf98a3228000c41ebf649785237aa549a0"
    sha256 cellar: :any,                 sonoma:        "c7273cc0434fe948abec8a1e03caee3b9fc9d31f38e6d4a0f578f9770473b3ef"
    sha256 cellar: :any,                 ventura:       "686428eacc0031fd4d2d02d61a6d338d224889303833f2ae49f10a6c9e1699ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04600e68f9f705027a601bf15bc4a9c6be9288c78db7e35325c05bb6aca22427"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesf640318e58f669b1a9e00f5c4453910682e2d9dd594334539c7b7817dabb765fanyio-4.7.0.tar.gz"
    sha256 "2f834749c602966b7d456a7567cafcb309f96482b5081d14ac93ccd457f9dd48"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httptools" do
    url "https:files.pythonhosted.orgpackagesa79ace5e1f7e131522e6d3426e8e7a490b3a01f39a6696602e1c4f33f9e94277httptools-0.6.4.tar.gz"
    sha256 "4e93eee4add6493b59a5c514da98c939b244fce4a0d8879cd3f466562f4b7d5c"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "uvloop" do
    url "https:files.pythonhosted.orgpackagesafc0854216d09d33c543f12a44b393c402e89a920b1a0a7dc634c42de91b9cf6uvloop-0.21.0.tar.gz"
    sha256 "3bf12b0fda68447806a7ad847bfa591613177275d35b6724b1ee573faa3704e3"
  end

  resource "watchfiles" do
    url "https:files.pythonhosted.orgpackages3c7e4569184ea04b501840771b8fcecee19b2233a8b72c196061263c0ef23c0bwatchfiles-1.0.3.tar.gz"
    sha256 "f3ff7da165c99a5412fe5dd2304dd2dbaaaa5da718aad942dcb3a178eaa70c56"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackagesf41b380b883ce05bb5f45a905b61790319a28958a9ab1e4b6b95ff5464b60ca1websockets-14.1.tar.gz"
    sha256 "398b10c77d471c0aab20a845e7a60076b6390bfdaac7a6d2edb0d2c59d75e8d8"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"uvicorn", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath"example.py").write <<~PYTHON
      async def app(scope, receive, send):
          assert scope['type'] == 'http'

          await send({
              'type': 'http.response.start',
              'status': 200,
              'headers': [
                  (b'content-type', b'textplain'),
              ],
          })
          await send({
              'type': 'http.response.body',
              'body': b'Hello, Homebrew!',
          })
    PYTHON

    port = free_port
    pid = fork do
      exec bin"uvicorn", "--port=#{port}", "example:app"
    end

    assert_match "Hello, Homebrew!", shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end