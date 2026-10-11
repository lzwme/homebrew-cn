class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/b0/70/fe20ba54d325c408ae96e5e08a0f3c399b37f4b6c6d7f14f3c74dc6942b7/yq-4.4.0.tar.gz"
  sha256 "bac64df0332bebf05cd6ff2bbd35e421a79bfe29d7c57ee021033a12cd8202cd"
  license "Apache-2.0"
  head "https://github.com/kislyuk/yq.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "6b82600fcf81dc4b917450ffb74e59fa581d30eb868e05694deab3f036fd4764"
    sha256 cellar: :any, arm64_tahoe:       "bb2d9d806dba4f638b01fa204330d576d02c61c2ea79817635cab124ac4b1796"
    sha256 cellar: :any, arm64_sequoia:     "5a8d2dae6a8dd88862322f4977df169bcedc5a6f57f76d3bb52e7164851f9a35"
    sha256 cellar: :any, arm64_linux:       "5c57c2274435258e371f638cd4fe674b5a6f6425e82ce26449954e8874a7029c"
    sha256 cellar: :any, x86_64_linux:      "2e940a17bccbb7acb678326c16833b1dddc7aa78ba436e01e0c3ebcf37b0ef42"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

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