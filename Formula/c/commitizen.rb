class Commitizen < Formula
  include Language::Python::Virtualenv

  desc "Defines a standard way of committing rules and communicating it"
  homepage "https:commitizen-tools.github.iocommitizen"
  url "https:files.pythonhosted.orgpackagesa6e6a9a890fc64f712ace191c230545f7121507071754e9728d4a91bdb385bf9commitizen-3.18.3.tar.gz"
  sha256 "980eb09abfb27d0d16960a6ca9e40c78b8608205987d8b012e3c09347bc4d35d"
  license "MIT"
  head "https:github.comcommitizen-toolscommitizen.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0272d2825aacf1fd99978772ba638685e7c18f95a73597775af54b117119afe4"
    sha256 cellar: :any,                 arm64_ventura:  "212177defa5318dd7b6780bac1422b87bca7656b7a7e6fe51fd529849bb487b8"
    sha256 cellar: :any,                 arm64_monterey: "c0131f3fd49cff83dd4cfa012d0ca6d92a46c606c838c5266510ee7cc36302e5"
    sha256 cellar: :any,                 sonoma:         "53d785acdb10d79d5890bff85669977acdd17f95f3c6222199871fa22f6de430"
    sha256 cellar: :any,                 ventura:        "54b34feaf8f2f471a1aa43a13137a00b1e755f9cc64f8b2c7760904653f87fcc"
    sha256 cellar: :any,                 monterey:       "60e2df65e598947d4e914e9193ff59a9b342a2b580fc22ab3192b891b3cea7ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b36a04750f595c02b25967d05a86cd62900038de2f211e06759c5a278ab7a5d"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages3cc0031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9argcomplete-3.2.3.tar.gz"
    sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decli" do
    url "https:files.pythonhosted.orgpackages2e9cb76485e6120795c8b632707bafb4a9a4a2b75584ca5277e3e175c5d02225decli-0.6.1.tar.gz"
    sha256 "ed88ccb947701e8e5509b7945fda56e150e2ac74a69f25d47ac85ef30ab0c0f0"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackages64dd7467b3be0e863401438a407411f78c33376748aff39ec0b8f45f6739c86cimportlib_metadata-7.0.2.tar.gz"
    sha256 "198f568f3230878cb1b44fbd7975f87906c22336dba2e4a7f05278c281fbd792"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesfb93180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "questionary" do
    url "https:files.pythonhosted.orgpackages84d0d73525aeba800df7030ac187d09c59dc40df1c878b4fab8669bdc805535dquestionary-2.0.1.tar.gz"
    sha256 "bcce898bf3dbb446ff62830c86c5c6fb9a22a54146f0f5597d3da43b10d8fc8b"
  end

  resource "termcolor" do
    url "https:files.pythonhosted.orgpackages1056d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages7d494c0764898ee67618996148bdba4534a422c5e698b4dbf4001f7c6f930797tomlkit-0.12.4.tar.gz"
    sha256 "7ca1cfc12232806517a8515047ba66a19369e71edf2439d0f5824f91032b6cc3"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages5803dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(
      libexec"binregister-python-argcomplete", "cz",
      base_name:              "cz",
      shell_parameter_format: :arg
    )
  end

  test do
    # Generates a changelog after an example commit
    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "yes | #{bin}cz commit"
    system "#{bin}cz", "changelog"

    # Verifies the checksum of the changelog
    expected_sha = "97da642d3cb254dbfea23a9405fb2b214f7788c8ef0c987bc0cde83cca46f075"
    output = File.read(testpath"CHANGELOG.md")
    assert_match Digest::SHA256.hexdigest(output), expected_sha
  end
end