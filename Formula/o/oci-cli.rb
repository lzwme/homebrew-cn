class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https:docs.cloud.oracle.comiaasContentAPIConceptscliconcepts.htm"
  url "https:files.pythonhosted.orgpackagese18a0ad0a2f0af1835428af5004a6587dcf7f78a42a1cb2c5f5c245235ff656foci-cli-3.44.0.tar.gz"
  sha256 "afb84e4bd78e65150a63b326d1c4d9a27ccc7a7672bfb68a7850d642ba5a8cca"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https:github.comoracleoci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c128a402a1d5e6b8c2f7d99653ff56796053aaf0d9801916b8c5b285a7cd88a1"
    sha256 cellar: :any,                 arm64_ventura:  "96dace4b542a670f4740125f7052542625c445b990d828df2389870e0e6575f5"
    sha256 cellar: :any,                 arm64_monterey: "76f78cc675f8818a0206fa0969eacfd51ad1675be3092959f2702635442bdd49"
    sha256 cellar: :any,                 sonoma:         "3f55edcf229b51f2df1c443d0d125ea187408af31d82329984fd210621da77c9"
    sha256 cellar: :any,                 ventura:        "fc1e6fa314de564d559ac2c08e59b78f01e78cef367ffa89e2731db7946839ac"
    sha256 cellar: :any,                 monterey:       "8139fc315b6fd343c8767d3743eef46f4f872f6ffc1b382f537d88b721f27471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dd136653b5cb4ee5eec73038b767fa020b0472b43995732162271f33b7a8714"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "circuitbreaker" do
    url "https:files.pythonhosted.orgpackages92ec7f1dd19e3878f5391afb508e6a2fd8d9e5b176ca2992b90b55926c7341d8circuitbreaker-1.4.0.tar.gz"
    sha256 "80b7bda803d9a20e568453eb26f3530cd9bf602d6414f6ff6a74c611603396d2"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesddcf706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages3c563f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "oci" do
    url "https:files.pythonhosted.orgpackages0eb096d57962bca85ecc37ec536817000786a17554ac06cd6534aa77cb3cae61oci-2.129.0.tar.gz"
    sha256 "9f2b82dfd1d74e623f48b430763ec33fe7c0e290c8f9d1b0c4a7f822bb3289a9"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages91a8cbeec652549e30103b9e6147ad433405fdd18807ac2d54e6dbb73184d8a1pyOpenSSL-24.1.0.tar.gz"
    sha256 "cabed4bfaa5df9f1a16c0ef64a0cb65318b5cd077a7eda7d6970131ca2f41a6f"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "terminaltables" do
    url "https:files.pythonhosted.orgpackagesf5fc0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages61c5c3a4d72ffa8efc2e78f7897b1c69ec760553246b67d3ce8c4431fac5d4e3types-python-dateutil-2.9.0.20240316.tar.gz"
    sha256 "5d2f2e240b86905e40944dd787db6da9263f0deabef1076ddaed797351ec0202"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when released: https:github.commatthewdeanmartinterminaltablespull1
    resource("terminaltables").stage do
      inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
      inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'
      venv.pip_install_and_link Pathname.pwd
    end

    venv.pip_install resources.reject { |r| r.name == "terminaltables" }
    venv.pip_install_and_link buildpath
  end

  test do
    version_out = shell_output("#{bin}oci --version")
    assert_match version.to_s, version_out

    assert_match "Usage: oci [OPTIONS] COMMAND [ARGS]", shell_output("#{bin}oci --help")
    assert_match "", shell_output("#{bin}oci session validate", 1)
  end
end