class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://files.pythonhosted.org/packages/55/39/d638b7d8012468fe13c072bfb283cd917b12dbcb8e7a10b414d5109b0852/remarshal-0.17.1.tar.gz"
  sha256 "826a41d3e3ed9d45422811488d7b28cc146a8d5b2583b18db36302f87091a86d"
  license "MIT"
  head "https://github.com/dbohdan/remarshal.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bf72aa11af22843eba5b44cf613f415948ffecb0059db703fd41469f7c1093b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39d779e0d79b5d63b783111b901e58a50f63e316350ec706b5ea1ed4e06ab19c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08cf4c29a86b0132a5f53b1d51233138a4c5196470003745c9e9fe6c02fef458"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd53e6c8ac8d177893d7922fbdc13bbfa0357b745028cf851184e861722bea3c"
    sha256 cellar: :any_skip_relocation, ventura:        "b4a49846c36fd9a27864256865c307df7e1cc0f4dc8f19b280686b87c9e00c1f"
    sha256 cellar: :any_skip_relocation, monterey:       "88f51612c7da35c253b1631984d72d2e50ba667c3483870b71f7792943f400cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eafe2e9622869ceb3c9f2d235b60263fe926705e940e27922dc5c1e3c61c4ad"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/55/82/20ab03a2a43338927e722e51db457d4d8b56332539612dedb56bbe44e07d/cbor2-5.5.0.tar.gz"
    sha256 "380a427faed0202236dccca6b1dc0491f35c0598bdb6cac983616f6106127bd7"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/e5/d0/18209bb95db8ee693a9a04fe056ab0663c6d6b1baf67dd50819dd9cd4bd7/pytest-7.4.2.tar.gz"
    sha256 "a766259cfab564a2ad52cb1aae1b881a75c3eb7e34ca3779697c23ed47c47069"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0d/07/d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1b/tomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  resource "u-msgpack-python" do
    url "https://files.pythonhosted.org/packages/36/9d/a40411a475e7d4838994b7f6bcc6bfca9acc5b119ce3a7503608c4428b49/u-msgpack-python-2.8.0.tar.gz"
    sha256 "b801a83d6ed75e6df41e44518b4f2a9c221dc2da4bcd5380e3a0feda520bc61a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = "{\"foo.bar\":\"baz\",\"qux\":1}"
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

    assert_match version.to_s, shell_output("#{bin}/remarshal --version")
  end
end