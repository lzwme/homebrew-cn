class Commitizen < Formula
  include Language::Python::Virtualenv

  desc "Defines a standard way of committing rules and communicating it"
  homepage "https:commitizen-tools.github.iocommitizen"
  url "https:files.pythonhosted.orgpackages0cf627b408b625c01339accb5914c8d604012e49d0bb1900484ec759254214b5commitizen-3.24.0.tar.gz"
  sha256 "088e01ae8265f1d6fa5a4d11a05e4fd7092d958c881837c35f6c65aad27331a9"
  license "MIT"
  head "https:github.comcommitizen-toolscommitizen.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4bcaadc5ce0b1509bad184adf3113a3efba8b1b1bad5a2ad8f4d302137a2eb7"
    sha256 cellar: :any,                 arm64_ventura:  "847890554bf59f8314f6e0a039068bec8203201088972d888575b440208c3290"
    sha256 cellar: :any,                 arm64_monterey: "0b7f178caf19a67dfc91691fec4733cea0ef44c1a5f8b4d79ec791dabeb0dc59"
    sha256 cellar: :any,                 sonoma:         "5e62dedc7fd99638776feecb4db0fb61b24572e5a050a8f7fd3cf5005717b6f9"
    sha256 cellar: :any,                 ventura:        "3d5300f710e14e958938a83e0c8045683bc1421d3166ec0a16bfd43b60bcda66"
    sha256 cellar: :any,                 monterey:       "4174b8661d37ecc20ecaf7e9f9fe05da6bcf9146cec947c73018a169583c1e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fdcb34edd08565a8de12a44b876da3e3293f3f64bd464682576f7beb025749f"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7951fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
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
    url "https:files.pythonhosted.orgpackagesa0fcc4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
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
    url "https:files.pythonhosted.orgpackages3eef65da662da6f9991e87f058bc90b91a935ae655a16ae5514660d6460d1298zipp-3.18.1.tar.gz"
    sha256 "2884ed22e7d8961de1c9a05142eb69a247f120291bc0206a00a7642f09b5b715"
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