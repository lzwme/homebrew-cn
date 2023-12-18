class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https:github.comdbohdanremarshal"
  url "https:files.pythonhosted.orgpackages5539d638b7d8012468fe13c072bfb283cd917b12dbcb8e7a10b414d5109b0852remarshal-0.17.1.tar.gz"
  sha256 "826a41d3e3ed9d45422811488d7b28cc146a8d5b2583b18db36302f87091a86d"
  license "MIT"
  head "https:github.comdbohdanremarshal.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "240fd7de8e029415b684ae3b51f653777d7bb52c619441612ef12eec19c78d39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f868ee501ead6292edbe83b5609de61df260aca1f0712a2baee1f624457bb04f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cab565d8321e6729917c6861d0382aa88f55dea2ee4fe194ca7122868d2daf24"
    sha256 cellar: :any_skip_relocation, sonoma:         "920348f603e12fc8e921b0883d692b1493a5ff1e4863412a10f2ddbb0eecd267"
    sha256 cellar: :any_skip_relocation, ventura:        "fbf1453edc30d44a6b6c91b26f8f3d3a0ed3c511897680b3da5d31854fbb9485"
    sha256 cellar: :any_skip_relocation, monterey:       "7ab63aae4c514fd98793566dce093f88aa3ad838055ce8c2fc62732242f76a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93fb1be06e221de3b0474686e87d1611533be31130130be7a8a6935574027136"
  end

  depends_on "python-dateutil"
  depends_on "python-pluggy"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  conflicts_with "msgpack-tools", because: "both install 'json2msgpack' binary"

  resource "cbor2" do
    url "https:files.pythonhosted.orgpackages558220ab03a2a43338927e722e51db457d4d8b56332539612dedb56bbe44e07dcbor2-5.5.0.tar.gz"
    sha256 "380a427faed0202236dccca6b1dc0491f35c0598bdb6cac983616f6106127bd7"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackagese5d018209bb95db8ee693a9a04fe056ab0663c6d6b1baf67dd50819dd9cd4bd7pytest-7.4.2.tar.gz"
    sha256 "a766259cfab564a2ad52cb1aae1b881a75c3eb7e34ca3779697c23ed47c47069"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackages0d07d34a911a98e64b07f862da4b10028de0c1ac2222ab848eaf5dd1877c4b1btomlkit-0.12.1.tar.gz"
    sha256 "38e1ff8edb991273ec9f6181244a6a391ac30e9f5098e7535640ea6be97a7c86"
  end

  resource "u-msgpack-python" do
    url "https:files.pythonhosted.orgpackages369da40411a475e7d4838994b7f6bcc6bfca9acc5b119ce3a7503608c4428b49u-msgpack-python-2.8.0.tar.gz"
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
    assert_equal yaml, pipe_output("#{bin}remarshal -if=json -of=yaml", json)
    assert_equal yaml, pipe_output("#{bin}json2yaml", json)
    assert_equal toml, pipe_output("#{bin}remarshal -if=yaml -of=toml", yaml)
    assert_equal toml, pipe_output("#{bin}yaml2toml", yaml)
    assert_equal json, pipe_output("#{bin}remarshal -if=toml -of=json", toml).chomp
    assert_equal json, pipe_output("#{bin}toml2json", toml).chomp
    assert_equal pipe_output("#{bin}remarshal -if=yaml -of=msgpack", yaml),
      pipe_output("#{bin}remarshal -if=json -of=msgpack", json)

    assert_match version.to_s, shell_output("#{bin}remarshal --version")
  end
end