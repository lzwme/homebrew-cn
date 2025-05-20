class Subliminal < Formula
  include Language::Python::Virtualenv

  desc "Library to search and download subtitles"
  homepage "https:subliminal.readthedocs.io"
  url "https:files.pythonhosted.orgpackages50fc24c86cc9bf5ef2543a14cbff1e71a81165e760e2dfc61814ac3d7d9bfa9dsubliminal-2.3.2.tar.gz"
  sha256 "e9adee230b8bf46e27214da71ada18a3a0107d968005a25be3db5bc5855fb433"
  license "MIT"
  head "https:github.comDiaoulsubliminal.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89e9b5653bef08b98c7aadd32c4ba43ac2de99e06bd0262363610306eaa3d4fb"
    sha256 cellar: :any,                 arm64_sonoma:  "b917dace927ebeecd2c07ac9745a930bad38700d92c0477496339823d158ebd6"
    sha256 cellar: :any,                 arm64_ventura: "e0dabb47c2c7e35acb43c697b5bbaf9f3e07fc019854cdd4109219b86cc3466d"
    sha256 cellar: :any,                 sonoma:        "2b9561dc44b60dcaa6c2014a5a79774cb26a094d59c417db05fe5ec612a4e3ed"
    sha256 cellar: :any,                 ventura:       "e3acb57168a60dfb9d51df4ed4c84999f6dfea49794979371c7f44e73bc86092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e79867f5d9e1bc2c819f792936f481b8b24f0dda8338b85ed38504bf46dba8f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dd9c2c602ae779c37025b10a75e2af65736847fd5fe3befd8efa22376e81bc6"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "babelfish" do
    url "https:files.pythonhosted.orgpackagesc58f17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesd8e40c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6bbeautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagescd0f62ca20172d4f87d93cf89665fbaedcd560ac48b465bd1d92bfc7ea6b0a41click-8.2.0.tar.gz"
    sha256 "f5452aeddd9988eefa20f90f05ab66f17fce1ee2a36907fd30b05bbb5953814d"
  end

  resource "click-option-group" do
    url "https:files.pythonhosted.orgpackagesb99f1f917934da4e07ae7715a982347e3c2179556d8a58d1108c5da3e8f09c76click_option_group-0.5.7.tar.gz"
    sha256 "8dc780be038712fc12c9fecb3db4fe49e0d0723f9c171d7cda85c20369be693c"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages43fa6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6bdecorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "dogpile-cache" do
    url "https:files.pythonhosted.orgpackagese8072257f13f9cd77e71f62076d220b7b59e1f11a70b90eb1e3ef8bdf0f14b34dogpile_cache-1.4.0.tar.gz"
    sha256 "b00a9e2f409cf9bf48c2e7a3e3e68dac5fa75913acbf1a62f827c812d35f3d09"
  end

  resource "enzyme" do
    url "https:files.pythonhosted.orgpackages6ed8a390f96ac0ccc33ca1c0e5c9cb9fc73f0623117e310594b6bc3be87005deenzyme-0.5.2.tar.gz"
    sha256 "7cf779148d9e66eb2838603eace140c53c3cefc8b8fe5d4d5a03a5fb5d57b3c1"
  end

  resource "flexcache" do
    url "https:files.pythonhosted.orgpackages55b08a21e330561c65653d010ef112bf38f60890051d244ede197ddaa08e50c1flexcache-0.3.tar.gz"
    sha256 "18743bd5a0621bfe2cf8d519e4c3bfdf57a269c15d1ced3fb4b64e0ff4600656"
  end

  resource "flexparser" do
    url "https:files.pythonhosted.orgpackages8299b4de7e39e8eaf8207ba1a8fa2241dd98b2ba72ae6e16960d8351736d8702flexparser-0.4.tar.gz"
    sha256 "266d98905595be2ccc5da964fe0a2c3526fbbffdc45b65b3146d75db992ef6b2"
  end

  resource "guessit" do
    url "https:files.pythonhosted.orgpackagesd0075a88020bfe2591af2ffc75841200b2c17ff52510779510346af5477e64cdguessit-3.8.0.tar.gz"
    sha256 "6619fcbbf9a0510ec8c2c33744c4251cad0507b1d573d05c875de17edc5edbed"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "knowit" do
    url "https:files.pythonhosted.orgpackages3a0f229a93f213c77bc0fef300cf973fb39bd72b0cbed80c8c441cb9b106a1abknowit-0.5.6.tar.gz"
    sha256 "6ca8fe4b93d6ec3ff753a8f6f3c641020a6801c11d42545ccb270523281f8cca"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages01d2510cc0d218e753ba62a1bc1434651db3cd797a9716a0a66cc714cb4f0935pbr-6.1.1.tar.gz"
    sha256 "93ea72ce6989eb2eed99d0f75721474f69ad88128afdef5ac377eb797c4bf76b"
  end

  resource "pint" do
    url "https:files.pythonhosted.orgpackages20bb52b15ddf7b7706ed591134a895dbf6e41c8348171fb635e655e0a4bbb0eapint-0.24.4.tar.gz"
    sha256 "35275439b574837a6cd3020a5a4a73645eb125ce4152a73a2f126bf164b91b80"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pymediainfo" do
    url "https:files.pythonhosted.orgpackages0feda02b18943f9162644f90354fe6445410e942c857dd21ded758f630ba41c0pymediainfo-6.1.0.tar.gz"
    sha256 "186a0b41a94524f0984d085ca6b945c79a254465b7097f2560dc0c04e8d1d8a5"
  end

  resource "pysubs2" do
    url "https:files.pythonhosted.orgpackages314abecf78d9d3df56e6c4a9c50b83794e5436b6c5ab6dd8a3f934e94c89338cpysubs2-1.8.0.tar.gz"
    sha256 "3397bb58a4a15b1325ba2ae3fd4d7c214e2c0ddb9f33190d6280d783bb433b20"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rebulk" do
    url "https:files.pythonhosted.orgpackagesf20624c69f8d707c9eefc1108a64e079da56b5f351e3f59ed76e8f04b9f3e296rebulk-3.2.0.tar.gz"
    sha256 "0d30bf80fca00fa9c697185ac475daac9bde5f646ce3338c9ff5d5dc1ebdfebc"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages9e8bdc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackages3ff44a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19fsoupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "srt" do
    url "https:files.pythonhosted.orgpackages66b74a1bc231e0681ebf339337b0cd05b91dc6a0d701fa852bb812e244b7a030srt-3.5.3.tar.gz"
    sha256 "4884315043a4f0740fd1f878ed6caa376ac06d70e135f306a6dc44632eed0cc0"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackages283f13cacea96900bbd31bb05c6b74135f85d15564fc583802be56976c940470stevedore-5.4.1.tar.gz"
    sha256 "3135b5ae50fe12816ef291baff420acb727fcd356106e3e9cbfa9e5985cd6f4b"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesb109a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fatomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "trakit" do
    url "https:files.pythonhosted.orgpackages2c4d93938a1c55f685cb12176759e645a7d048c8ba07678d98e58e4b29d10955trakit-0.2.2.tar.gz"
    sha256 "42e8b7af9949620d12647cd4b9801125d04a15a9ad8bb832230b26b78a723700"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"subliminal", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath".config").mkpath
    system bin"subliminal", "download", "-l", "en",
               "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.mp4"
    assert_path_exists testpath"The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.en.srt"
  end
end