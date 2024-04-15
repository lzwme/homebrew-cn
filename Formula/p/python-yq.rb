class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/e1/4b/26a31d6016596d27a06f158ae04b7b27d3c51cd15e444a0d5dbac03c0298/yq-3.3.0.tar.gz"
  sha256 "d2ab562f11b1e0e5b9654b9b06d43f8a205269cc7bda2ce077325f5a123651dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e75a0092bae8c43a5d29bc446734fc74b92c83e9529dcce5380fc5e4a6963c6a"
    sha256 cellar: :any,                 arm64_ventura:  "d8cb114fa829371abfaefb01b7c0fc94297b1dbbbab3b47487f82a3052fc35cd"
    sha256 cellar: :any,                 arm64_monterey: "997b0d958c3f2b9af03a11ca89016f2af9beccb1a40b2157b47eae1e047acdab"
    sha256 cellar: :any,                 sonoma:         "59ddada15e40ffd145b4f19f76b43d4abf1e639536c5c8278f801d962fca92b4"
    sha256 cellar: :any,                 ventura:        "bd5c9c2f8c89c93f1e3da75c6b4d29b84631f6926a977494572c4d3a09a9fba2"
    sha256 cellar: :any,                 monterey:       "00248558eae93f4f47c995a5f52e67b9074cfdc263970d6a890666a98bef0745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0a0359a83f703878759c8ced34625db9a2b0fc9073d10ce3116f5c43b5db1ff"
  end

  depends_on "jq"
  depends_on "libyaml"
  depends_on "python@3.12"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3c/c0/031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9/argcomplete-3.2.3.tar.gz"
    sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
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