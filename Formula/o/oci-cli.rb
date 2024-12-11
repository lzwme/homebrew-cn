class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https:docs.cloud.oracle.comiaasContentAPIConceptscliconcepts.htm"
  url "https:files.pythonhosted.orgpackages8a65bae743b7236d3b0c0d4cb2de0da22965208d9988cb47e60f850414deb0c1oci_cli-3.50.3.tar.gz"
  sha256 "4306f84e6a5927fabd060ba426529d9049b8817f19569de5ff5a857c45904eb8"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https:github.comoracleoci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a15f4f7f253ee54637b5235179beaf90b878889a08e044f28af613fc9265e967"
    sha256 cellar: :any,                 arm64_sonoma:  "efe8002bf6f1048b5f60e42d8fdfc1dacad1bd7d2c18fa550fd0dd37378a08e5"
    sha256 cellar: :any,                 arm64_ventura: "ae22aa2254f2e77c92e0c18543633ee5914d7033e4b3f0fa0e0aa02a48e90490"
    sha256 cellar: :any,                 sonoma:        "6980e54526798a525ce460751bbbd0d4b4a8cac4c186f3d98b70161a69554eb2"
    sha256 cellar: :any,                 ventura:       "d09846570586be8a3cb148c188f688741a0da8796f845669a094d790a483602d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "155859bd421bc8544cd735c0c7b557f057c292951e9065b5b432e2a32158a548"
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
    url "https:files.pythonhosted.orgpackagesa09ad9c0c60a55b9f3625e5a9390afe4805de6b77c12e678939271e59da70766oci-2.140.0.tar.gz"
    sha256 "a71ceb95c919ce100778c33119bf9e6adee552003630ff161a3daa8cda0021f6"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pyopenssl" do
    url "https:files.pythonhosted.orgpackagesc1d41067b82c4fc674d6f6e9e8d26b3dff978da46d351ca3bac171544693e085pyopenssl-24.3.0.tar.gz"
    sha256 "49f7a019577d834746bc55c5fce6ecbcec0f2b4ec5ce1cf43a9a173b8138bb36"
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
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "terminaltables" do
    url "https:files.pythonhosted.orgpackagesf5fc0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackagesa96047d92293d9bc521cd2301e423a358abfac0ad409b3a1606d8fbae1321961types_python_dateutil-2.9.0.20241206.tar.gz"
    sha256 "18f493414c26ffba692a72369fea7a154c502646301ebfe3d56a04b3767284cb"
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