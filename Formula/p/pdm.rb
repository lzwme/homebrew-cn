class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package and dependency manager supporting the latest PEP standards"
  homepage "https:pdm.fming.dev"
  url "https:files.pythonhosted.orgpackagesff55baf970b59fea776bd6e6257c521e36b2d3c3d11a76cd050720a60f50344bpdm-2.15.1.tar.gz"
  sha256 "1c9cd049c1016633a23ef92ec1fc782da8ae0743142ef33faf7d48872f874b39"
  license "MIT"
  head "https:github.compdm-projectpdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d0f7f65c547cd435f4003c5f780869bb59c6e3dc4405203f8ad2e915ccefa3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41f1031eead2538b8119f96b441c015a5a1d9f00bee7eff1d5f4af3119747c17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12c97fff159dd570d1ece942d16f16b68ec0b4eda73986b534c72f7f273cd341"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d8925010756bc3f342113c982b455e9e46d00d91e6a9732e87d81a67874500e"
    sha256 cellar: :any_skip_relocation, ventura:        "034c5ae97f0c20644c86bbda4d38043a12d63927c9ff29a98922e80090dccbdf"
    sha256 cellar: :any_skip_relocation, monterey:       "ff404a4187cf7aef7a57d07f4127d0c56aeb03388c583a65996845f9edb7565d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9977479d2341cb47881526243cc527292b8b526dd508552ae747b0bcf6f255e0"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesdb4d3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackagesa1136df5fc090ff4e5d246baf1f45fe9e5623aa8565757dfa5bd243f6a545f9eblinker-1.7.0.tar.gz"
    sha256 "e6820ff6fa4e4d1d8e2747c2283749c3f547e4fee112b98555cdcdae32996182"
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
    url "https:files.pythonhosted.orgpackages38ff877f1dbe369a2b9920e2ada3c9ab81cf6fe8fa2dce45f40cad510ef2df62filelock-3.13.4.tar.gz"
    sha256 "d13f466618bfde72bd2c18255e269f72542c6e70e7bac83a0232d6b1cc5c8cf4"
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
    url "https:files.pythonhosted.orgpackagesbc511a535bbbb7d2fbd30853c62a26d5d66c2d77549b750d9f3fce4f238ae3e1pbs_installer-2024.4.1.tar.gz"
    sha256 "1f2aca82511fb9e1973b14708d7386780a8c56d111b680ae5786b3f430fa918a"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesb2e42856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackages25c1374304b8407d3818f7025457b7366c8e07768377ce12edfe2aa58aa0f64cpyproject_hooks-1.0.0.tar.gz"
    sha256 "f271b298b97f5955d53fb12b72c1fb1948c22c1a6b70b315c54cedaca0264ef5"
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
    url "https:files.pythonhosted.orgpackages7d494c0764898ee67618996148bdba4534a422c5e698b4dbf4001f7c6f930797tomlkit-0.12.4.tar.gz"
    sha256 "7ca1cfc12232806517a8515047ba66a19369e71edf2439d0f5824f91032b6cc3"
  end

  resource "truststore" do
    url "https:files.pythonhosted.orgpackages25fa852059855159181dba77129770834e419e0235ecf99a2c0e0d15a2b18a31truststore-0.8.0.tar.gz"
    sha256 "dc70da89634944a579bfeec70a7a4523c53ffdb3cf52d1bb4a431fda278ddb96"
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
    url "https:files.pythonhosted.orgpackagesd8020737e7aca2f7df4a7e4bfcd4de73aaad3ae6465da0940b77d222b753b474virtualenv-20.26.0.tar.gz"
    sha256 "ec25a9671a5102c8d2657f62792a27b48f016664c6873f6beed3800008577210"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackagesb8d6ac9cd92ea2ad502ff7c1ab683806a9deb34711a1e2bd8a59814e8fc27e69wheel-0.43.0.tar.gz"
    sha256 "465ef92c69fa5c5da2d1cf8ac40559a8c940886afcef87dcf14b9470862f1d85"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackages5d912162ab4239b3bd6743e8e407bc2442fca0d326e2d77b3f4a88d90ad5a1fazstandard-0.22.0.tar.gz"
    sha256 "8226a33c542bcb54cd6bd0a366067b610b41713b64c9abec1bc4533d69f51e70"
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