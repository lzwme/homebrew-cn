class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/e3/c6/adfbfb59eda5d2eccf2e0af9e906b9919febe62bc444f2f5891944c2be9f/yq-3.2.3.tar.gz"
  sha256 "29c8fe1d36b4f64163f4d01314c6ae217539870f610216dee6025dfb5eafafb1"
  license "Apache-2.0"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e8b3ed115a18be3f2dd9a673b297369dc4c0e12c358c604c9e41210e2eb9775"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7bba9994b1127c69e8fd8cda70e483875003ac48d2ff4721877c6a4f2e6f01d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d3d582fe3391801d3789c0aca487c4b3337cdb99caf215a30d35ebe25442c6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c99b002316eb5a01dade67cf813e1bc96405d6fafee29c504dec1f0a5fecd2f8"
    sha256 cellar: :any_skip_relocation, ventura:        "7e20037c3efa17d35e917eb6e369dd4eca98b358a92e564083b03194c4484b0c"
    sha256 cellar: :any_skip_relocation, monterey:       "f5a3158d68ca11187b65e6aeaa23e3228db0735b410a30f6f1ad27593509d15a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f678c0102d10126d0fd16e95ae98039bfc6ff4088d53ccb64b6b9c375b905e"
  end

  depends_on "jq"
  depends_on "python-argcomplete"
  depends_on "python@3.12"
  depends_on "pyyaml"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources

    python3 = "python3.12"
    register_argcomplete = Formula["python-argcomplete"].opt_bin/"register-python-argcomplete"
    %w[yq xq tomlq].each do |script|
      generate_completions_from_executable(
        python3, register_argcomplete, script,
        base_name:              script,
        shell_parameter_format: :arg
      )
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