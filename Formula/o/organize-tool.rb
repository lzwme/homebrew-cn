class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https:github.comtfeldmannorganize"
  url "https:files.pythonhosted.orgpackages461164cd44c8accd864c1f3e67a8185b60434834d50e0876a961554ceb9a64f7organize_tool-3.1.2.tar.gz"
  sha256 "03ef0bc8a179a31a302b65f0b2a725cc949946075dd13cd1fb72c2307dda9fbe"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "5d6b61e6e74bb835e8e560cfbd391ecf09345150d50e097c86edf022df4c986d"
    sha256 cellar: :any,                 arm64_ventura:  "4fc085ebd1bdcfb9d78e079bc653694cbd0b52c150697506e532b1c0b67251e5"
    sha256 cellar: :any,                 arm64_monterey: "dc9b93b5f2bba098c7121f7aafd5a87fe33dd5a58290db6a9063a581b1024012"
    sha256 cellar: :any,                 sonoma:         "89a4dac1fa7902ef589eb5f395235448dabff6169fe755869617d3ef487edc5d"
    sha256 cellar: :any,                 ventura:        "af738e6e0d65dd106ae035dbdc9f60bdd9ffe6800ae3db41c12ba52d3a0ed5f9"
    sha256 cellar: :any,                 monterey:       "bb146d44bf39fb8bb52fbebc42bef3de9db14c9881a580004b8b323ff82a00b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bc0a9b18d1b5110b1a845c2d8ab68875f7d0172a920bb4e8314c149d2728121"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build # for pydantic_core
  depends_on "freetype"
  depends_on "openjpeg"
  depends_on "python@3.12"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackages68ce95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91dcffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "docopt-ng" do
    url "https:files.pythonhosted.orgpackagese4508d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  resource "exifread" do
    url "https:files.pythonhosted.orgpackages5fa6e5bdca841e5cc1a0eb7b9bf64854a4bf4e19e6de1a14092f93b8c907e87aExifRead-2.3.2.tar.gz"
    sha256 "a0f74af5040168d3883bbc980efe26d06c89f026dc86ba28eb34107662d51766"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "macos-tags" do
    url "https:files.pythonhosted.orgpackagesd46ee0b2ea37ef831a5c6b5aebbd14701d96d9dc061f04a867b05335a4bc099dmacos-tags-1.5.1.tar.gz"
    sha256 "f144c5bc05d01573966d8aca2483cb345b20b76a5b32e9967786e086a38712e7"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mdfind-wrapper" do
    url "https:files.pythonhosted.orgpackages0e74148968c2665c0f2db1fbd470fbb454b1f808ea5d4cb8d75bc99f451d0ecemdfind-wrapper-0.1.5.tar.gz"
    sha256 "c0dbd5bc99c6d1fb4678bfa1841a3380ccac61e9b43a26a8d658aa9cafe27441"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages5e0b95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46depycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackages7327a17cc261bb974e929aa3b3365577e43c1c71c3dcd8669250613a7135cb8fpydantic-2.6.1.tar.gz"
    sha256 "4fd5c182a2488dc63e6d32737ff19937888001e2a6d86e94b3f233104a5d1fa9"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages0d7264550ef171432f97d046118a9869ad774925c2f442589d5f6164b8288e85pydantic_core-2.16.2.tar.gz"
    sha256 "0ba503850d8b8dcc18391f10de896ae51d37fe5fe43dbfb6a35c5c5cad271a06"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyobjc-core" do
    url "https:files.pythonhosted.orgpackages50d50b93cb9dc94ab4b78b2b7aa54c80f037e4de69897fff81a5ededa91d2704pyobjc-core-10.1.tar.gz"
    sha256 "1844f1c8e282839e6fdcb9a9722396c1c12fb1e9331eb68828a26f28a3b2b2b1"
  end

  resource "pyobjc-framework-cocoa" do
    url "https:files.pythonhosted.orgpackages5d1d964a0da846d49511489bd99ed705f9d85c5081fc832d0dba384c4c0d2fb2pyobjc-framework-Cocoa-10.1.tar.gz"
    sha256 "8faaf1292a112e488b777d0c19862d993f3f384f3927dc6eca0d8d2221906a14"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "send2trash" do
    url "https:files.pythonhosted.orgpackages4ad2d4b4d8b1564752b4e593c6d007426172b6574df5a7c07322feba010f5551Send2Trash-1.8.2.tar.gz"
    sha256 "c132d59fa44b9ca2b1699af5c86f57ce9f4c5eb56629d5d55fbb7a35f84e2312"
  end

  resource "simplematch" do
    url "https:files.pythonhosted.orgpackagesd4c5209aa49f6c366f5b1d80e9eef2f75270079df3c9dec4658e0716e4bcd6absimplematch-1.4.tar.gz"
    sha256 "55a77278b3d0686cb38e3ffe5a326a5f59c2995f1ba1fa1a4f68872c17caf4cb"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages9b472a9e51ae8cf48cea0089ff6d9d13fff60701f8c9bf72adaee0c4e5dc88f9types-python-dateutil-2.8.19.20240106.tar.gz"
    sha256 "1f8db221c3b98e6ca02ea83a58371b22c374f42ae5bbdf186db9c9a76581459f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackages0c1deb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "xattr" do
    url "https:files.pythonhosted.orgpackages91ac5898d1811abc88c3710317243168feff61ce12be220b9c92ee045ecd66c4xattr-0.9.9.tar.gz"
    sha256 "09cb7e1efb3aa1b4991d6be4eb25b73dc518b4fe894f0915f5b0dcede972f346"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    venv = virtualenv_create(libexec, "python3.12")
    # `macos-tags` and `pyobjc-framework-cocoa` + dependencies are only needed on macOS
    # TODO: Currently requires manual check to confirm PyPI dependency tree
    skipped = %w[macos-tags mdfind-wrapper xattr cffi pycparser]
    skipped += %w[pyobjc-framework-cocoa pyobjc-core]
    venv.pip_install resources.reject { |r| OS.linux? && skipped.include?(r.name) }
    venv.pip_install_and_link buildpath
  end

  test do
    config_file = testpath"config.yaml"
    config_file.write <<~EOS
      rules:
        - locations: #{testpath}
          filters:
            - extension: txt
          actions:
            - echo: 'Found: {path.name}'
            - delete
    EOS

    touch testpath"homebrew.txt"

    assert_match "Found: homebrew.txt", shell_output("#{bin}organize sim #{config_file}")
    system bin"organize", "run", config_file
    refute_predicate testpath"homebrew.txt", :exist?
  end
end