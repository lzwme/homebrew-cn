class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https:www.uvicorn.org"
  url "https:files.pythonhosted.orgpackages0a96ee52d900f8e41cc35eaebfda76f3619c2e45b741f3ee957d6fe32be1b2aauvicorn-0.31.0.tar.gz"
  sha256 "13bc21373d103859f68fe739608e2eb054a816dea79189bc3ca08ea89a275906"
  license "BSD-3-Clause"
  head "https:github.comencodeuvicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8f19eb23d3b2b9d81591445a1aff694e70ff4e829fe54ba33a3d5d686cac563"
    sha256 cellar: :any,                 arm64_sonoma:  "10a287808d79e8888a969637e29ab7fb477d05fcab862667b633834c0dd28ae2"
    sha256 cellar: :any,                 arm64_ventura: "61ecf1a603335160f371dc1333db46cd1ffb5d75b4e83f1643a8b441a89bf5be"
    sha256 cellar: :any,                 sonoma:        "dfae37a5ff333514b0d12eb78c906add6901a84260ee60e059cce29690e5c333"
    sha256 cellar: :any,                 ventura:       "343df83f3ab6f2fd658babf5b342b6f4cb04f373de403935c4e98ecf42ba85f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8edefd86ac2ede9dab4d89b800555d13de57d4684a3c4ca6194ad100922411bd"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages7849f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
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
    url "https:files.pythonhosted.orgpackages671dd77686502fced061b3ead1c35a2d70f6b281b5f723c4eff7a2277c04e4a2httptools-0.6.1.tar.gz"
    sha256 "c6e26c30455600b95d94b1b836085138e82f177351454ee841c148f93a9bad5a"
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
    url "https:files.pythonhosted.orgpackagesbcf1dc9577455e011ad43d9379e836ee73f40b4f99c02946849a44f7ae64835euvloop-0.20.0.tar.gz"
    sha256 "4603ca714a754fc8d9b197e325db25b2ea045385e8a3ad05d3463de725fdf469"
  end

  resource "watchfiles" do
    url "https:files.pythonhosted.orgpackagesc8272ba23c8cc85796e2d41976439b08d52f691655fdb9401362099502d1f0cfwatchfiles-0.24.0.tar.gz"
    sha256 "afb72325b74fa7a428c009c1b8be4b4d7c2afedafb2982827ef2156646df2fe1"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackagese2739223dbc7be3dcaf2a7bbf756c351ec8da04b1fa573edaf545b95f6b0c7fdwebsockets-13.1.tar.gz"
    sha256 "a3b3366087c1bc0a2795111edcadddb8b3b59509d5db5d7ea3fdd69f954a8878"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"uvicorn", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath"example.py").write <<~EOS
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
    EOS

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