class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://files.pythonhosted.org/packages/1a/7e/d0a6fcf1ebce08975b742416e97d79ce8ea5a338280a930980ee61f4b75f/remarshal-0.15.1.tar.gz"
  sha256 "d35d7300d1d690c7c3754fb5456ca1efcb4749dc3568933a252f9cde3cb7f9d0"
  license "MIT"
  head "https://github.com/dbohdan/remarshal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc4c45360cf993f17424487c9708a7f30268ceccdeff6fd4cd18ab576eb64b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66a0ec21d7e786ef2695476c49e9d60f6cb23ff2c6efae7d708dd136eb956076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0052193e9811751ce596ffb157fce53aa5e8bbb1f1f4d3a696ed9718a4348d8b"
    sha256 cellar: :any_skip_relocation, ventura:        "050d35e11f9eaa27f05fb61aca8a6790c0d541bee5a82a504862e6ac0f86b2c7"
    sha256 cellar: :any_skip_relocation, monterey:       "66503c50d34a86fb8f56d2029d451820bfacc53e2093796d8dcc2694cbbddee6"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba5bc418315bb9d9a87eb24feaf60aef018881ddd2b0bcf260fef978576bb3b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6656f43403523ee8f1f12f4cc4ec96d32a98a64112cfbd4bc11036044373ae0"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/69/de486293f5211d2e8fe1a19854e69f2811a18448162c52b48c67f8fbcac3/cbor2-5.4.6.tar.gz"
    sha256 "b893500db0fe033e570c3adc956af6eefc57e280026bd2d86fd53da9f1e594d7"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/8a/42/8f2833655a29c4e9cb52ee8a2be04ceac61bcff4a680fb338cbd3d1e322d/pluggy-1.2.0.tar.gz"
    sha256 "d12f0c4b579b15f5e054301bb226ee85eeeba08ffec228092f8defbaa3a4c4b3"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/a7/f3/dadfbdbf6b6c8b5bd02adb1e08bc9fbb45ba51c68b0893fa536378cdf485/pytest-7.4.0.tar.gz"
    sha256 "b4bf8c45bd59934ed84001ad51e11b4ee40d40a1229d2c79f9c592b0a3f6bd8a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/10/37/dd53019ccb72ef7d73fff0bee9e20b16faff9658b47913a35d79e89978af/tomlkit-0.11.8.tar.gz"
    sha256 "9330fc7faa1db67b541b28e62018c17d20be733177d290a13b24c62d1614e0c3"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/36/9d/a40411a475e7d4838994b7f6bcc6bfca9acc5b119ce3a7503608c4428b49/u-msgpack-python-2.8.0.tar.gz"
    sha256 "b801a83d6ed75e6df41e44518b4f2a9c221dc2da4bcd5380e3a0feda520bc61a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~EOS.chomp
      {"foo.bar":"baz","qux":1}
    EOS
    yaml = <<~EOS.chomp
      foo.bar: baz
      qux: 1

    EOS
    toml = <<~EOS.chomp
      "foo.bar" = "baz"
      qux = 1

    EOS
    assert_equal yaml, pipe_output("#{bin}/remarshal -if=json -of=yaml", json)
    assert_equal yaml, pipe_output("#{bin}/json2yaml", json)
    assert_equal toml, pipe_output("#{bin}/remarshal -if=yaml -of=toml", yaml)
    assert_equal toml, pipe_output("#{bin}/yaml2toml", yaml)
    assert_equal json, pipe_output("#{bin}/remarshal -if=toml -of=json", toml).chomp
    assert_equal json, pipe_output("#{bin}/toml2json", toml).chomp
    assert_equal pipe_output("#{bin}/remarshal -if=yaml -of=msgpack", yaml),
      pipe_output("#{bin}/remarshal -if=json -of=msgpack", json)
  end
end