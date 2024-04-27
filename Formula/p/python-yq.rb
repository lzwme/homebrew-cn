class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/52/c3/8b463e37c949aeb56208a6db6892b4b14c332681afd57bf6c297ca6b3d0f/yq-3.4.2.tar.gz"
  sha256 "f916408e834e96f390ef82a36bfcbf24a555ae5a2fcdaef94a2ed5d260d161ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b713929dcf2d3ef71f8cb47ef1623586e12a8de9002e7beff45fbf5c22976c31"
    sha256 cellar: :any,                 arm64_ventura:  "227a96cea42a98c8c5f608b5efe6dda42d711c0dd5ea73a85a2e17e836b85ab3"
    sha256 cellar: :any,                 arm64_monterey: "e32df97938b4f443b268eb926896cff8b2f7f0474580a5fbd33166cbff4a0071"
    sha256 cellar: :any,                 sonoma:         "75a782dc726877efb35ef04fb68180622a5fb874688b64e1d46c817328aeb97f"
    sha256 cellar: :any,                 ventura:        "d386366414bd2bbbbb1a8b6dce7faf761e830dd3d24a8dadfa0db1742b5b4ab5"
    sha256 cellar: :any,                 monterey:       "418b439548f341855376582d97a86eb7533dc3f461e38103548f8c9aceb53ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c191a791b326b0b3060b77a316e3622cc96a95b0439bfaf67e4a183289775954"
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