class Commitizen < Formula
  include Language::Python::Virtualenv

  desc "Defines a standard way of committing rules and communicating it"
  homepage "https:commitizen-tools.github.iocommitizen"
  url "https:files.pythonhosted.orgpackages19a4f12219c1423de0381e0030c0411f787a875a987c2c217d563e9720055f3ccommitizen-3.13.0.tar.gz"
  sha256 "53cd225ae44fc25cb1582f5d50cda78711a5a1d44a32fee3dcf7a22bc204ce06"
  license "MIT"
  revision 1
  head "https:github.comcommitizen-toolscommitizen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49c824640c0c468017166dd5737299f25606ff99a09b2d0c2febbcb149f6f5d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f55a7265faa31943d1d62c0b1d390fab40aeadbb4b2f7f55681951cfc9744f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f4571f61717fc2bd021e1c7736b7bc46a53e28eb10d789782b2539468d94e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3d8ca63e9d934a9a18ab656688f1655be44036de004395d099da3f21497f1e6"
    sha256 cellar: :any_skip_relocation, ventura:        "9e0fd61d98b823b466eedecbb99a2c2e43a85f73f48b74aeae5f6aaa26d80a05"
    sha256 cellar: :any_skip_relocation, monterey:       "cbcf192a60828d13f51232f61f51f8aa2c7865b71ebebb2c0dba5daa355a2a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d3b912a37235ea77ab1cd750ea08ff1c8e8b6431575e4072c8a3bb42604ccce"
  end

  depends_on "python-argcomplete"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"

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
    url "https:files.pythonhosted.orgpackageseeeb58c2ab27ee628ad801f56d4017fe62afab0293116f6d0b08f1d5bd46e06fimportlib_metadata-6.11.0.tar.gz"
    sha256 "1231cf92d825c9e03cfc4da076a16de6422c863558229ea0b22b675657463443"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesfb93180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
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
    url "https:files.pythonhosted.orgpackagesdffc1201a374b9484f034da4ec84215b7b9f80ed1d1ea989d4c02167afaa4400tomlkit-0.12.3.tar.gz"
    sha256 "75baf5012d06501f07bee5bf8e801b9f343e7aac5a92581f20f80ce632e6b5a4"
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

    python_exe = Formula["python@3.12"].opt_libexec"binpython"
    register_argcomplete = Formula["python-argcomplete"].opt_bin"register-python-argcomplete"
    generate_completions_from_executable(
      python_exe, register_argcomplete, "cz",
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