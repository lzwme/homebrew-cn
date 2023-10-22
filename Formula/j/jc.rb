class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/34/dd/edf3143224e9f566fe982c4fa47184c2a67f439cbd3ed2edd6f3c17abd5e/jc-1.23.5.tar.gz"
  sha256 "bba586461f5cb4b11ac8b66a5827a26f8521f1973b28b55a45049c12b720f6fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a954cf76792812527baaf04cd3cc5182e88f855ec29328553f0fd42647f5183"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc69934a298181b6daa4f0747b0d5522e7b4b83b2ff5bb7499e9305325ae8c85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ecb579123b82ae0a86a19fcda47231bad112965d54bd2fea78caaa0b42ca3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca2aed74511cc48f3ff303a0d50902c1d5ac65679bb485e6f7f506b41919ec5e"
    sha256 cellar: :any_skip_relocation, ventura:        "bce31a80525012be36c1823bcc27cfca5832e4142f464dbf02587720b5cae36b"
    sha256 cellar: :any_skip_relocation, monterey:       "e49f2a9061e2b3d37777645958f48e6f2da7ad788ad780fc33842f9c7ebb9494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d362b19b5dcf7272d9d68b60225ef2ce47bb1c73ea5c94d658525e8083b7691"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/d1/d6/eb2833ccba5ea36f8f4de4bcfa0d1a91eb618f832d430b70e3086821f251/ruamel.yaml-0.17.40.tar.gz"
    sha256 "6024b986f06765d482b5b07e086cc4b4cd05dd22ddcbc758fa23d54873cf313d"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jc.1"
    generate_completions_from_executable(bin/"jc", "--bash-comp", shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin/"jc", "--zsh-comp", shells: [:zsh], shell_parameter_format: :none)
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n",
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end