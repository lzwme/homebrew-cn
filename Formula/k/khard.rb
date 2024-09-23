class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https:github.comlucckhard"
  url "https:files.pythonhosted.orgpackages0d00215a69d2ae96cac511a6594116958bf13e210dd24f78c48f5ffaf039edeckhard-0.19.1.tar.gz"
  sha256 "59f30a0da3c3da3eb04f4dbe18ee4763913b685d99ec8418fd574a88c491c490"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dacd018c2c3d83389801225a85f64ea89fabfe16eee2f46150527d1ebd8a28a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37ca59ac0e7e22e14583b1e8675bde01efe9b8426b7a5a2ef341c64f87268ec7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43f1e2b0bbdbe145388e8bc5a516535652c3a10ad6253fa2462e87cbbbd7205a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa7c6c810a38fe1a596bdaa10ca48b008ababad4b510241358b1430e9d79d3cb"
    sha256 cellar: :any_skip_relocation, ventura:       "44f7928787d9ead6e0b26a1dc620195cf0c4d42ceef5ad1017a214c00008456d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2744fd9ad7e0683787ca0336e8c04ea5cd6aebdb9fcb383f596aecb715f3004"
  end

  depends_on "python@3.12"

  resource "atomicwrites" do
    url "https:files.pythonhosted.orgpackages87c653da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "configobj" do
    url "https:files.pythonhosted.orgpackagesf5c4c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
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
    url "https:files.pythonhosted.orgpackagesbf61cd63d29d987e5dd8c971571e68c32e4fc365b17155556808c6d99e0fd0c7vobject-0.9.7.tar.gz"
    sha256 "ab727bf81de88984ada5c11f066f1e1649903d3e3d7ec91f1ce968172afd5256"
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