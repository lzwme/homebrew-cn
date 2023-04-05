class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/70/97/afd9a4999bf7d278803e7a5861a870a5fa7635f68d6f32d86367c542a99e/yq-3.2.0.tar.gz"
  sha256 "be44e0222afdc79d8aa6d8c5f5c5e4e404a278272f23ccf7f3a672fd0750bd55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f880655c6db60f52f065b5a04ea8968d27941e822222a71c46dc09b4d320b016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b4d9890fe3e551e6e06a11c8ab15668db40d540edc760ea76637c8e2a6a0fd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c78eeeb305ccc9b97b83a978536d1993904a2a8316a2ea13b7f5e5a3c3025b2"
    sha256 cellar: :any_skip_relocation, ventura:        "979c7d0d9e58b7a96fa2dba709bb94db81b6bdc118c1911a9b48b69bad496a81"
    sha256 cellar: :any_skip_relocation, monterey:       "579624d76725da1c4cd8a7ce13a116968387945035cd0161017070ce9e90f318"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8844b73f8e997916a7e4c62202b4f0600fbb107fccd26c985b68eaea9bf0f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02d0ecba502156fa75e6979ee706a25b5dd60a6204f4625f719e1bd388290b10"
  end

  depends_on "jq"
  depends_on "python@3.11"
  depends_on "pyyaml"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/9d/50/e5b3e9824a387920c4b92870359c9f7dbf21a6cd6d3dff5bf4fd3b50237a/argcomplete-3.0.5.tar.gz"
    sha256 "fe3ce77125f434a0dd1bffe5f4643e64126d5731ce8d173d36f62fa43d6eb6f7"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/4d/4e/6cb8a301134315e37929763f7a45c3598dfb21e8d9b94e6846c87531886c/tomlkit-0.11.7.tar.gz"
    sha256 "f392ef70ad87a672f02519f99967d28a4d3047133e2d1df936511465fbb3791d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
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