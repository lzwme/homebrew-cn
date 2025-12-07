class PolicySentry < Formula
  include Language::Python::Virtualenv

  desc "Generate locked-down AWS IAM Policies"
  homepage "https://policy-sentry.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/2d/84/fc0594aead9d0bae80251f1415c0c76b053d7abeb2fd9a69a3993d88f6ec/policy_sentry-0.15.1.tar.gz"
  sha256 "5ab684b1a26970e33e7e8cb028eec93f1483616fb483c1c09568858a42983a30"
  license "MIT"
  revision 1
  head "https://github.com/salesforce/policy_sentry.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "526785fe1e35be9d254a5d797caa2089e67460f4636c1456d1522e355760d555"
    sha256 cellar: :any,                 arm64_sequoia: "001baac2fdea5e5db96469a5b809a6493b8adfbbd46dbc64945c663448bf80aa"
    sha256 cellar: :any,                 arm64_sonoma:  "9f591c4f58bd24b78133d6cd4b00b062c0b12ffa1a6d4ca20a5ede158388aeb0"
    sha256 cellar: :any,                 sonoma:        "4bc59826d36d4a9d8b9455a21fc8324163e12b0a11c804357f7084fb43e7c051"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3466acb291b03aa3a8cbabb3b421ee2139acedf11c0aeb1133fb9de287059917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6af049b7e8a8dae29436b4e34716af07b160bd9254107ef40471b98a1d54f881"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/c6/fe/ed708782d6709cc60eb4c2d8a361a440661f74134675c72990f2c48c785f/orjson-3.11.4.tar.gz"
    sha256 "39485f4ab4c9b30a3943cfe99e1a213c4776fb69e8abd68f66b83d5a0b0fdc6d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/fb/2e/8da627b65577a8f130fe9dfa88ce94fcb24b1f8b59e0fc763ee61abef8b8/schema-0.7.8.tar.gz"
    sha256 "e86cc08edd6fe6e2522648f4e47e3a31920a76e82cce8937535422e310862ab5"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"policy_sentry", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/policy_sentry --version")

    test_file = testpath/"policy_sentry.yml"
    output = shell_output("#{bin}/policy_sentry create-template -o #{test_file} -t actions")
    assert_match "write-policy template file written to: #{test_file}", output
    assert_match "mode: actions", test_file.read
  end
end