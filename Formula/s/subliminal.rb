class Subliminal < Formula
  include Language::Python::Virtualenv

  desc "Library to search and download subtitles"
  homepage "https:subliminal.readthedocs.io"
  url "https:files.pythonhosted.orgpackages32079ea2a7d67fbcc8ff132d72d6162548ad19b742a0350ddf2b82fe8a18a34esubliminal-2.2.0.tar.gz"
  sha256 "f103380d1e2ef09b7cb194beff5bf4a19492d5f3bbf336dec03a7451c992a593"
  license "MIT"
  head "https:github.comDiaoulsubliminal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83e5cbf4d08c12b0a4f33e20172ba94c299a4de4f8530696940729d3f38718db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83e5cbf4d08c12b0a4f33e20172ba94c299a4de4f8530696940729d3f38718db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83e5cbf4d08c12b0a4f33e20172ba94c299a4de4f8530696940729d3f38718db"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ddc0b09a97e669a5cbd40195bec33d4a04307c1b1bc4d9af87d41c91e496e6c"
    sha256 cellar: :any_skip_relocation, ventura:        "3ddc0b09a97e669a5cbd40195bec33d4a04307c1b1bc4d9af87d41c91e496e6c"
    sha256 cellar: :any_skip_relocation, monterey:       "3ddc0b09a97e669a5cbd40195bec33d4a04307c1b1bc4d9af87d41c91e496e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d36126b86f96f580b5394027b4e9b49e541463be777551a7d8fec090664e5af"
  end

  depends_on "certifi"
  depends_on "python@3.12"

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
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
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
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages8dc2ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pysubs2" do
    url "https:files.pythonhosted.orgpackages1f72e9d8ac5aeb431bd49666fb49a6f6cdabfa040917a95a320e0f75d22b694epysubs2-1.7.2.tar.gz"
    sha256 "b708904269cb252dbc51de75a372e04ab00c368939bb8220f7b0f940d978725e"
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
    url "https:files.pythonhosted.orgpackagesce21952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717bsoupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "srt" do
    url "https:files.pythonhosted.orgpackages66b74a1bc231e0681ebf339337b0cd05b91dc6a0d701fa852bb812e244b7a030srt-3.5.3.tar.gz"
    sha256 "4884315043a4f0740fd1f878ed6caa376ac06d70e135f306a6dc44632eed0cc0"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagese7c1b210bf1071c96ecfcd24c2eeb4c828a2a24bf74b38af13896d02203b1eecstevedore-5.2.0.tar.gz"
    sha256 "46b93ca40e1114cea93d738a6c1e365396981bb6bb78c27045b7587c9473544d"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackagesc03fd7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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