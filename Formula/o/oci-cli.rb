class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https:docs.cloud.oracle.comiaasContentAPIConceptscliconcepts.htm"
  url "https:files.pythonhosted.orgpackagesdf2d85629069c1bd58553f31dfa5d91175f57975ecd2bcda366e9c27ee4179c7oci_cli-3.56.1.tar.gz"
  sha256 "cab3bc62337e9e4d68e54930b83ad149cc8971d111f330c7444d556eab5bed8d"
  license any_of: ["UPL-1.0", "Apache-2.0"]
  head "https:github.comoracleoci-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f7ccbc6eae2cb9c67ea7519d7f015701ebf46519e2fb290d20e07b8576ec9070"
    sha256 cellar: :any,                 arm64_sonoma:  "474a7e3f441f552ab795925a68d0b25f1bc708ef921f9e4cc10f36b4b3387bc7"
    sha256 cellar: :any,                 arm64_ventura: "02b98f62f0cd6fdeee0b6aa12fa038579ab4c838062e1a1612ed971f90c07ade"
    sha256 cellar: :any,                 sonoma:        "03aeea16fa0281ad2e5e6aa8169bea3f8b176c9d1defb9b30f5a837db9b41261"
    sha256 cellar: :any,                 ventura:       "61dd22621ab27275bb2754c86db679576c53791f415d003aab69dc21d9d7392a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "634fe0e316194d04e04f8abf1f73761598943aeabb67af99f81a26ce6a51acd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64bfb52bd712321679adb02c4a6cd49260925c2f51cfb8212296f71b2e6d611e"
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
    url "https:files.pythonhosted.orgpackagesdfacde7a92c4ed39cba31fe5ad9203b76a25ca67c530797f6bb420fff5f65ccbcircuitbreaker-2.1.3.tar.gz"
    sha256 "1a4baee510f7bea3c91b194dcce7c07805fe96c4423ed5594b75af438531d084"
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
    url "https:files.pythonhosted.orgpackages8e9438474b246701764be0424ff4ed62a5fe7c8d5c27c63ebf6461637b7d1cd2oci-2.152.1.tar.gz"
    sha256 "87c185be9624b5ba9bcfd2e8ed619905a7c310f178cb42b70d31aadc5c6fc142"
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
    url "https:files.pythonhosted.orgpackagesf8bfabbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aacpytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
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
    url "https:files.pythonhosted.orgpackagesef88d65ed807393285204ab6e2801e5d11fbbea811adcaa979a2ed3b67a5ef41types_python_dateutil-2.9.0.20250516.tar.gz"
    sha256 "13e80d6c9c47df23ad773d54b2826bd52dbbb41be87c3f339381c1700ad21ee5"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    # Loosen `pyyaml` version pin: https:github.comoracleoci-clipull858
    inreplace "setup.py", "PyYAML>=5.4,<=6.0.1", "PyYAML>=5.4,<=6.0.2"

    venv = virtualenv_install_with_resources without: "terminaltables"

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when released: https:github.commatthewdeanmartinterminaltablespull1
    resource("terminaltables").stage do
      inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
      inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'
      venv.pip_install_and_link Pathname.pwd
    end

    generate_completions_from_executable(bin"oci", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    version_out = shell_output("#{bin}oci --version")
    assert_match version.to_s, version_out

    assert_match "Usage: oci [OPTIONS] COMMAND [ARGS]", shell_output("#{bin}oci --help")
    assert_match "Could not find config file", shell_output("#{bin}oci session validate 2>&1", 1)
  end
end