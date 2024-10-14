class Subliminal < Formula
  include Language::Python::Virtualenv

  desc "Library to search and download subtitles"
  homepage "https:subliminal.readthedocs.io"
  url "https:files.pythonhosted.orgpackagese32436cdb82e90afc602e2ed36c34e022ca545d35f5be9aa7ef9ddb0af7967b2subliminal-2.2.1.tar.gz"
  sha256 "2ed6024a07bbb3c68fe3db76374244ad91adfca9d93fc24d3ddb9ef61825756e"
  license "MIT"
  head "https:github.comDiaoulsubliminal.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5cab29a1b05ee7deb45af01ab28bff2bdff33369192772d7426c93001d97856"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5cab29a1b05ee7deb45af01ab28bff2bdff33369192772d7426c93001d97856"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5cab29a1b05ee7deb45af01ab28bff2bdff33369192772d7426c93001d97856"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f5087528add4235f52dac844c31cbc377f44ad6115918a9010bd59a65b94ed6"
    sha256 cellar: :any_skip_relocation, ventura:       "9f5087528add4235f52dac844c31cbc377f44ad6115918a9010bd59a65b94ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d41d4075abc823931f5a91b68c1e4aa71c309f6190f9d8093f1fd2733b6fed7c"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "babelfish" do
    url "https:files.pythonhosted.orgpackagesc58f17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesb3ca824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-option-group" do
    url "https:files.pythonhosted.orgpackagese7b891054601a2e05fd9060cb1baf56be5b24145817b059e078669e1099529c7click-option-group-0.5.6.tar.gz"
    sha256 "97d06703873518cc5038509443742b25069a3c7562d1ea72ff08bfadde1ce777"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dogpile-cache" do
    url "https:files.pythonhosted.orgpackages813b83ce66995ce658ad63b86f7ca83943c466133108f20edc7056d4e0f41347dogpile.cache-1.3.3.tar.gz"
    sha256 "f84b8ed0b0fb297d151055447fa8dcaf7bae566d4dbdefecdcc1f37662ab588b"
  end

  resource "enzyme" do
    url "https:files.pythonhosted.orgpackages6ed8a390f96ac0ccc33ca1c0e5c9cb9fc73f0623117e310594b6bc3be87005deenzyme-0.5.2.tar.gz"
    sha256 "7cf779148d9e66eb2838603eace140c53c3cefc8b8fe5d4d5a03a5fb5d57b3c1"
  end

  resource "guessit" do
    url "https:files.pythonhosted.orgpackagesd0075a88020bfe2591af2ffc75841200b2c17ff52510779510346af5477e64cdguessit-3.8.0.tar.gz"
    sha256 "6619fcbbf9a0510ec8c2c33744c4251cad0507b1d573d05c875de17edc5edbed"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackagesb23580cf8f6a4f34017a7fe28242dc45161a1baa55c41563c354d8147e8358b2pbr-6.1.0.tar.gz"
    sha256 "788183e382e3d1d7707db08978239965e8b9e4e5ed42669bf4758186734d5f24"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pysubs2" do
    url "https:files.pythonhosted.orgpackages27f0c496409796d038e65161b8cddc6925d4c2c53489fb6f690eb28027ecc58apysubs2-1.7.3.tar.gz"
    sha256 "b0130f373390736754531be4e68a0fa521e825fa15cc8ff506e4f8ca2c17459a"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "rarfile" do
    url "https:files.pythonhosted.orgpackages263f3118a797444e7e30e784921c4bfafb6500fb288a0c84cb8c32ed15853c16rarfile-4.2.tar.gz"
    sha256 "8e1c8e72d0845ad2b32a47ab11a719bc2e41165ec101fd4d3fe9e92aa3f469ef"
  end

  resource "rebulk" do
    url "https:files.pythonhosted.orgpackagesf20624c69f8d707c9eefc1108a64e079da56b5f351e3f59ed76e8f04b9f3e296rebulk-3.2.0.tar.gz"
    sha256 "0d30bf80fca00fa9c697185ac475daac9bde5f646ce3338c9ff5d5dc1ebdfebc"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "srt" do
    url "https:files.pythonhosted.orgpackages66b74a1bc231e0681ebf339337b0cd05b91dc6a0d701fa852bb812e244b7a030srt-3.5.3.tar.gz"
    sha256 "4884315043a4f0740fd1f878ed6caa376ac06d70e135f306a6dc44632eed0cc0"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagesc459f8aefa21020054f553bf7e3b405caec7f8d1f432d9cb47e34aaa244d8d03stevedore-5.3.0.tar.gz"
    sha256 "9a64265f4060312828151c204efbe9b7a9852a0d9228756344dbc7e4023e375a"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackages35b9de2a5c0144d7d75a57ff355c0c24054f965b2dc3036456ae03a51ea6264btomli-2.0.2.tar.gz"
    sha256 "d46d457a85337051c36524bc5349dd91b1877838e2979ac5ced3e710ed8a60ed"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath".config").mkpath
    system bin"subliminal", "download", "-l", "en",
               "The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.mp4"
    assert_predicate testpath"The.Big.Bang.Theory.S05E18.HDTV.x264-LOL.en.srt", :exist?
  end
end