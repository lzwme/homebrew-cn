class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package and dependency manager supporting the latest PEP standards"
  homepage "https:pdm.fming.dev"
  url "https:files.pythonhosted.orgpackagesf16f4f3c970b6c4257c3a60938e1339da3098716d72bd92845063887f7c2db3cpdm-2.15.3.tar.gz"
  sha256 "c227d81f6bf109626a5643a7bb531c5f5b777a850c4eac8d08b472c1146beee5"
  license "MIT"
  head "https:github.compdm-projectpdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3243fbc30fc00e9bf453f22a55bafff8435efb11ec6965d14f9cf1da47e8f60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8231b1cd4d2daf8545110478c210c2ebcd5694f92a5e3e7f82387a57ebad5cf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfd39befca863f483c36349e3e502197c19e32ecd87e75fdcd02f158b8754a6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "68fc39100e83dc3f26dc59bdcd5f02b41a390a4f77464bfd3662581fa04a97dc"
    sha256 cellar: :any_skip_relocation, ventura:        "4ab7000848b8efc03bf5f62f2974f3a367c062059a5354b29485583d3df84808"
    sha256 cellar: :any_skip_relocation, monterey:       "7debde72fd6f0e9d8719216fb4c46d9bd8aad0128d1bcd792499dd93f03e6636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b5dd5d8fdabe1718ba5bfdaee928f65475a3a686366ce655757b4a8ca17e58b"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesdb4d3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackages1e57a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abccblinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "dep-logic" do
    url "https:files.pythonhosted.orgpackages21d5c365826c3d0b65b9cc273bdf2e99022ada232fb95502f4efd98a8f9e31aadep_logic-0.2.0.tar.gz"
    sha256 "cff502b515aff2d413d19d6afc70174fc67da19e821be4a9b68460ccee2514c9"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages06aef8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897eafilelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "findpython" do
    url "https:files.pythonhosted.orgpackages2957a35de26696baa005ddcfce8af495fb8cdb75942ebebf1cf219a04706fc81findpython-0.6.1.tar.gz"
    sha256 "56e52b409a92bcbd495cf981c85acf137f3b3e51cc769b46eba219bb1ab7533c"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "hishel" do
    url "https:files.pythonhosted.orgpackages219ce97476b0e594ee9ad7af48701138b87d0a21387b4f0fcfcc803d5520fb14hishel-0.0.26.tar.gz"
    sha256 "f0ae2766214499cb0253a5ec7694f0d6e3835c9a35634356f8926fb7a1cf379e"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages17b05e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages5c2d3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "installer" do
    url "https:files.pythonhosted.orgpackages0518ceeb4e3ab3aa54495775775b38ae42b10a92f42ce42dfa44da684289b8c8installer-0.7.0.tar.gz"
    sha256 "a26d3e3116289bb08216e0d0f7d925fcef0b0194eedfa0c944bcaaa106c4b631"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackages084c17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pbs-installer" do
    url "https:files.pythonhosted.orgpackages08ae4cd6d39bd365ac440f6a0f11e3614356fc280a8717b22a36f73f139f59b4pbs_installer-2024.4.24.tar.gz"
    sha256 "19224733068b0ffa39b53afbb61544bee8ecb9503e7222ba034f07b9913e2c1c"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackagesc7076f63dda440d4abb191b91dc383b472dae3dd9f37e4c1e4a5c3db150531c6pyproject_hooks-1.1.0.tar.gz"
    sha256 "4b37730834edbd6bd37f26ece6b44802fb1c1ee2ece0e54ddff8bfc06db86965"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "resolvelib" do
    url "https:files.pythonhosted.orgpackagesce10f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "socksio" do
    url "https:files.pythonhosted.orgpackagesf85c48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages2bab18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
  end

  resource "truststore" do
    url "https:files.pythonhosted.orgpackages231d1f5435cee49c7897641c38537288c0cb070c15029cde9a895c876cf60758truststore-0.9.1.tar.gz"
    sha256 "8f7312d70cc33e9003b748a80a04ead1fcb2ed856a7c6c9ca5a02482901a90be"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "unearth" do
    url "https:files.pythonhosted.orgpackages4e27312c0976a8c35aca68b81bfd2cc3b5cc4b9c8901bfd1c9a6658ccee687b4unearth-0.15.2.tar.gz"
    sha256 "381f3e6969db0b28d9fc2fbfb216860579bf341bd695472f2c62e2bcce9e6d3d"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages445acabd5846cb550e2871d9532def625d0771f4e38f765c30dc0d101be33697virtualenv-20.26.2.tar.gz"
    sha256 "82bf0f4eebbb78d36ddaee0283d43fe5736b53880b8a8cdcd37390a07ac3741c"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin"pdm", "completion")
  end

  test do
    (testpath"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

      [build-system]
      requires = ["pdm-backend"]
      build-backend = "pdm.backend"
    EOS
    system bin"pdm", "add", "requests==2.31.0"
    assert_match "dependencies = [\n    \"requests==2.31.0\",\n]", (testpath"pyproject.toml").read
    assert_predicate testpath"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath"pdm.lock").read
    output = shell_output("#{bin}pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.31.0", output.strip
  end
end