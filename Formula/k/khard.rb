class Khard < Formula
  include Language::Python::Virtualenv

  desc "Console carddav client"
  homepage "https:github.comlucckhard"
  url "https:files.pythonhosted.orgpackages0d00215a69d2ae96cac511a6594116958bf13e210dd24f78c48f5ffaf039edeckhard-0.19.1.tar.gz"
  sha256 "59f30a0da3c3da3eb04f4dbe18ee4763913b685d99ec8418fd574a88c491c490"
  license "GPL-3.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fb20881e405b6a35eb802c83225d7099e6ca99c8979ab2dac3159412318aa1b5"
  end

  depends_on "python@3.13"

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

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages3a313c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3fpytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
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
    url "https:files.pythonhosted.orgpackages4706c477d9a8b75471243f2b4eeef39cb639a1cf978990c11e9e56359ab01c82vobject-0.9.8.tar.gz"
    sha256 "db00a7f4db49397155dd8a6871e8a2a0175a6eba5a654c30e910f82b29514b58"
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