class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/0b/c9/d678ff9fe791a7fb7bbe184220506dd6f39074d72260acb9744ec3f6bef4/yq-4.3.0.tar.gz"
  sha256 "8c8d0b0022e7c8226154d5a64195f2d1f5346f40063b3cb51e58ee3303ac9190"
  license "Apache-2.0"
  head "https://github.com/kislyuk/yq.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b03cba063260ed09399b555d79210db0ce017b815408aabd51ce377d45d1b4fe"
    sha256 cellar: :any, arm64_tahoe:       "12ead3168a7070a6f4220a5b32557ccddf5f1ca0750d6ba7509288f80b663efd"
    sha256 cellar: :any, arm64_sequoia:     "60bfa03973e41778b9663c4267af99a018e53428de0c4dd6f88d8e449f18fade"
    sha256 cellar: :any, arm64_linux:       "78d8d86d4010d1d2823649851f558e37caf26294a040b47451219919fad8bd43"
    sha256 cellar: :any, x86_64_linux:      "f1d6db065a50d069f8dbb1a4e84c51442471800de060992f2d6575cd5571ebd3"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "jq", since: :sequoia

  conflicts_with "yq", because: "both install `yq` executables"
  conflicts_with "xq", because: "both install `xq` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/19/70/80f3b7c10d2630aa66414bf23d210386700aa390547278c789afa994fd7e/xmltodict-1.0.4.tar.gz"
    sha256 "6d94c9f834dd9e44514162799d344d815a3a4faec913717a9ecbfa5be1bb8e61"
  end

  def install
    virtualenv_install_with_resources
    %w[yq xq tomlq].each do |script|
      generate_completions_from_executable(libexec/"bin/register-python-argcomplete", script,
                                           base_name: script, shell_parameter_format: :arg)
    end
  end

  test do
    input = <<~YAML
      foo:
       bar: 1
       baz: {bat: 3}
    YAML
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end