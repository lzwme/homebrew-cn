class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https:docs.cloud.oracle.comiaasContentAPIConceptscliconcepts.htm"
  url "https:files.pythonhosted.orgpackages194c466d900b6af4ea1a264f94c715981b36b60dfa35bb53f4790ebb2d3e4db2oci-cli-3.50.1.tar.gz"
  sha256 "3eb5a29f76eb1aaca7d894db0b759265a57a724ad6fa4db28e96dd7a27c1ed19"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https:github.comoracleoci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a91da2098e61c8e94be372f5243a79b11d5a0042ee3c1f7e2585613be4a1f3c2"
    sha256 cellar: :any,                 arm64_sonoma:  "1f1e60303ca02c3a4d635eec7a277ab58a9eb0a1a979b4f645c9b71496b1354f"
    sha256 cellar: :any,                 arm64_ventura: "fde333757e6f6d2e28b169c5e429f72345228333ce77eb1e9ac4c554914d8ee8"
    sha256 cellar: :any,                 sonoma:        "f9dd3c609b85af925963c0f7fff94351829adf8305e95a2b32c9a0fab74792c1"
    sha256 cellar: :any,                 ventura:       "ce066f6f1c4c244314935f5dd211d206c103c1384b5d6be7a9cfcb91fe7b28a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9147fa5864b142cc13277ce23cf995078c19fcda340be966b64766eaa6cb9270"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "circuitbreaker" do
    url "https:files.pythonhosted.orgpackages23573bc8f0885c6914336d0b2fe36bf740476f0c827b3fb991993d67c1a9d3f3circuitbreaker-2.0.0.tar.gz"
    sha256 "28110761ca81a2accbd6b33186bc8c433e69b0933d85e89f280028dbb8c1dd14"
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
    url "https:files.pythonhosted.orgpackages0402ec70d8ee3a810f770984598714dee5f96beb0d74fce3bd0c9c2c796b189aoci-2.138.1.tar.gz"
    sha256 "f7f27be6b0dc5f56a567b5340a6f4c96d3a484c15418a1c3b47aed1c4be979c9"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackages5d70ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages3a313c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3fpytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
    url "https:files.pythonhosted.orgpackages31f8f6ee4c803a7beccffee21bb29a71573b39f7037c224843eff53e5308c16etypes-python-dateutil-2.9.0.20241003.tar.gz"
    sha256 "58cb85449b2a56d6684e41aeefb4c4280631246a0da1a719bdbe6f3fb0317446"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    # Loosen `pyyaml` version pin: https:github.comoracleoci-clipull858
    inreplace "setup.py", "PyYAML>=5.4,<=6.0.1", "PyYAML>=5.4,<=6.0.2"
    venv = virtualenv_create(libexec, "python3.13")

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