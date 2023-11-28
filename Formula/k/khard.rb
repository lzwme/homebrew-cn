class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https://github.com/scheibler/khard/"
  url "https://files.pythonhosted.org/packages/0d/00/215a69d2ae96cac511a6594116958bf13e210dd24f78c48f5ffaf039edec/khard-0.19.1.tar.gz"
  sha256 "59f30a0da3c3da3eb04f4dbe18ee4763913b685d99ec8418fd574a88c491c490"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34687e03a06151c017e73d961efefe20f32b1cc111c83f92f9cc05b92e663321"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cfba89e9af7781723d35bd502771df176d4e391fc9b1a03b50c5c1c1b2e858d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ed61a1b027bea298598d3a628a5a4d8d5b0ae1bf6f126506480239f89b2fde2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d715c9003cca7ae2bb78cefcd5a65bf1a5fbb5b9e91ce5660149f329c6e6594"
    sha256 cellar: :any_skip_relocation, ventura:        "4690b2ca3cec83fe1d435e8e52ae0285e8eb871eacd0cf6f1660bd19e8fc4dc8"
    sha256 cellar: :any_skip_relocation, monterey:       "861363612fe66fb88ffc4b6065f2cf1677481db51b340202275702c06e21da8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c229765e86f1a6fb152037e5a408a81a46452f10e6fcdd23509b993d4ad6143"
  end

  depends_on "python-dateutil"
  depends_on "python@3.12"
  depends_on "six"

  resource "atomicwrites" do
    url "https://files.pythonhosted.org/packages/87/c6/53da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2/atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/82/43/fa976e03a4a9ae406904489119cd7dd4509752ca692b2e0a19491ca1782c/ruamel.yaml-0.18.5.tar.gz"
    sha256 "61917e3a35a569c1133a8f772e1226961bf5a1198bea7e23f06a0841dea1ab0e"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/46/ab/bab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295b/ruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/80/5d/f156f6a7254ecc0549de0eb75f786d2df724c0310b97c825383517d2c98d/Unidecode-1.3.7.tar.gz"
    sha256 "3c90b4662aa0de0cb591884b934ead8d2225f1800d8da675a7750cbc3bd94610"
  end

  resource "vobject" do
    url "https://files.pythonhosted.org/packages/da/ce/27c48c0e39cc69ffe7f6e3751734f6073539bf18a0cfe564e973a3709a52/vobject-0.9.6.1.tar.gz"
    sha256 "96512aec74b90abb71f6b53898dd7fe47300cc940104c4f79148f0671f790101"
  end

  def install
    virtualenv_install_with_resources
    (etc/"khard").install "doc/source/examples/khard.conf.example"
    zsh_completion.install "misc/zsh/_khard"
    pkgshare.install (buildpath/"misc").children - [buildpath/"misc/zsh"]
  end

  test do
    (testpath/".config/khard/khard.conf").write <<~EOS
      [addressbooks]
      [[default]]
      path = ~/.contacts/
      [general]
      editor = /usr/bin/vi
      merge_editor = /usr/bin/vi
      default_country = Germany
      default_action = list
      show_nicknames = yes
    EOS
    (testpath/".contacts/dummy.vcf").write <<~EOS
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    assert_match "Address book: default", shell_output("#{bin}/khard list user")
  end
end