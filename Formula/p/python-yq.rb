class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/e2/96/5dcb699d1dee50ca43ee60c1eae531e4430a404c5a5d90568e1f19274e26/yq-3.4.1.tar.gz"
  sha256 "b558dab6f15c03e24a1c448789500b20d6f307ee9ca4c9361387f3658163000d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c5176d4b3e6aa633980a5a985273c25c24271ec845812e5e9697ca82217396db"
    sha256 cellar: :any,                 arm64_ventura:  "5cc1c46a4bed9854eb3b1e7f5af3c6ead7ffe1183ba6d421233c827983a0419a"
    sha256 cellar: :any,                 arm64_monterey: "b0943855dc49eb393d32f5d96d43342137cf781c003915dbb9b2888ec0f4142d"
    sha256 cellar: :any,                 sonoma:         "ca2aa0b9316984dd1171e7b8ae198803487518550d23caff004a011763652b7e"
    sha256 cellar: :any,                 ventura:        "5d7af71b604ae92dfc117f048f3d5471c2e456fb4cb5cbfcec24020d82b8e977"
    sha256 cellar: :any,                 monterey:       "2682258e23d57c3f93080f8f367d4c749ee188094c92920b1e341a5a47fb386e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f582c20449bb61e4376d40d6caad684440b712e85b3fc7083d02ce948a9c44f"
  end

  depends_on "jq"
  depends_on "libyaml"
  depends_on "python@3.12"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/79/51/fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587/argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/7d/49/4c0764898ee67618996148bdba4534a422c5e698b4dbf4001f7c6f930797/tomlkit-0.12.4.tar.gz"
    sha256 "7ca1cfc12232806517a8515047ba66a19369e71edf2439d0f5824f91032b6cc3"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
    %w[yq xq tomlq].each do |script|
      generate_completions_from_executable(libexec/"bin/register-python-argcomplete", script,
                                           shell_parameter_format: :arg)
    end
  end

  test do
    input = <<~EOS
      foo:
       bar: 1
       baz: {bat: 3}
    EOS
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end