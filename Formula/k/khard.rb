class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https:github.comlucckhard"
  url "https:files.pythonhosted.orgpackages0d00215a69d2ae96cac511a6594116958bf13e210dd24f78c48f5ffaf039edeckhard-0.19.1.tar.gz"
  sha256 "59f30a0da3c3da3eb04f4dbe18ee4763913b685d99ec8418fd574a88c491c490"
  license "GPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f9b2c8fb26f1aa5971e0003a83ee62f487fc4d5cf3764aba7aa210dc92c3a30b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12c493c9abf94b3f10b017495a3b449c4cc39157d9fb0011e8883f5ad74e3dc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5b035c1c64cb832d196d05d31e19e560e634563911a24e27bdc6b7cfe5bcdc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be118a4d08c2218ca87117c9736e19d022c62e610d511853eb6c28df2234f805"
    sha256 cellar: :any_skip_relocation, sonoma:         "1036b2f525fdd11fa8403a8df63cfa70564c732b4e229759bc8469da1f4c6c32"
    sha256 cellar: :any_skip_relocation, ventura:        "da152b6cbeb428e9f78d5441f4a1634008058400a4d179e7faf5456843300b4c"
    sha256 cellar: :any_skip_relocation, monterey:       "07e0937662235e3fd83a9003ee0b429f605657d1ad7870cf431178fc1d46ab35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3424b22114f87f72ce97b058b29852a940af162d93695c1905ad5522a6580b0d"
  end

  depends_on "python@3.12"

  resource "atomicwrites" do
    url "https:files.pythonhosted.orgpackages87c653da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagescb8717d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fbconfigobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "unidecode" do
    url "https:files.pythonhosted.orgpackagesf78919151076a006b9ac0dd37b1354e031f5297891ee507eb624755e58e10d3eUnidecode-1.3.8.tar.gz"
    sha256 "cfdb349d46ed3873ece4586b96aa75258726e2fa8ec21d6f00a591d98806c2f4"
  end

  resource "vobject" do
    url "https:files.pythonhosted.orgpackagesdace27c48c0e39cc69ffe7f6e3751734f6073539bf18a0cfe564e973a3709a52vobject-0.9.6.1.tar.gz"
    sha256 "96512aec74b90abb71f6b53898dd7fe47300cc940104c4f79148f0671f790101"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    virtualenv_install_with_resources
    (etc"khard").install "docsourceexampleskhard.conf.example"
    zsh_completion.install "misczsh_khard"
    pkgshare.install (buildpath"misc").children - [buildpath"misczsh"]
  end

  test do
    (testpath".configkhardkhard.conf").write <<~EOS
      [addressbooks]
      [[default]]
      path = ~.contacts
      [general]
      editor = usrbinvi
      merge_editor = usrbinvi
      default_country = Germany
      default_action = list
      show_nicknames = yes
    EOS
    (testpath".contactsdummy.vcf").write <<~EOS
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    assert_match "Address book: default", shell_output("#{bin}khard list user")
  end
end