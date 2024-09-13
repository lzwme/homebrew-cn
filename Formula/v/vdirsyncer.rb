class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https:github.compimutilsvdirsyncer"
  url "https:files.pythonhosted.orgpackageseec250eb6b430f447c062ae3cd07d1a354d768bdb1443580bd4ae16ec8c8296dvdirsyncer-0.19.3.tar.gz"
  sha256 "e437851feb985dec3544654f8f9cf6dd109b0b03f7e19956086603092ffeb28f"
  license "BSD-3-Clause"
  head "https:github.compimutilsvdirsyncer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c1d448ee0b5d16d3c8249c3d1cd48a90551463c7f6bc083116bd19dc98163a46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4b9590b025713f51dea822eed392107456194e861f39c2711ebcf03458f78f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acba1c84254f77ea7d3010add6a8f7d1c491a37dc768d2c0b80dfd19efd0c2e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d02f5134c5c77a1554409af4c9983755b87e28996436dd6baa516a3078882212"
    sha256 cellar: :any_skip_relocation, sonoma:         "d96065ec0ead9bc61f950622eaed167505287b69b947dbcb73dcd23b1f512b24"
    sha256 cellar: :any_skip_relocation, ventura:        "b03e053fc056fbdce5616707009f0b75ede77d1402cb5f5808771133d9708693"
    sha256 cellar: :any_skip_relocation, monterey:       "52f5887f4eaabd11d0384cbefaab246f7c52b6fc81167eb66e8f8be4a752c3ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d3160468683a01439c09fd39931cf5c297b20ef80ef6607f00698240fd66f36"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2df722bba300a16fd1cad99da1a23793fe43963ee326d012fdf852d0b4035955aiohappyeyeballs-2.4.0.tar.gz"
    sha256 "55a1714f084e63d49639800f95716da97a1f173d46a16dfcfda0016abb93b6b2"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesca28ca549838018140b92a19001a8628578b0f2a3b38c16826212cc6f706e6d4aiohttp-3.10.5.tar.gz"
    sha256 "f071854b47d39591ce9a17981c46790acb30518e2f83dfca8db2dfa091178691"
  end

  resource "aiohttp-oauthlib" do
    url "https:files.pythonhosted.orgpackagesba0acc204fcc311324358252fd38a884b1acae9f9e3936a54b2ce139946daadaaiohttp-oauthlib-0.1.0.tar.gz"
    sha256 "893cd1a59ddd0c2e4e980e3a544f9710b7c4ffb9e27b4cd038b51fe1d70393b7"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "aiostream" do
    url "https:files.pythonhosted.orgpackages9f92e10c6232f2e2e21a24ae9e6534292bd2d808ae43b719298f5599a2a38e4baiostream-0.4.5.tar.gz"
    sha256 "3ecbf87085230fbcd9605c32ca20c4fb41af02c71d076eab246ea22e35947d88"
  end

  resource "atomicwrites" do
    url "https:files.pythonhosted.orgpackages87c653da25344e3e3a9c01095a89f16dbcda021c609ddb42dd6d7c0528236fb2atomicwrites-1.4.1.tar.gz"
    sha256 "81b2c9071a49367a7f770170e5eec8cb66567cfbbc8c73d20ce5ca4a8d71cf11"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-log" do
    url "https:files.pythonhosted.orgpackages3232228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesd6be504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese43d4924f9ed49698bac5f112bc9b40aa007bbdcd702462c1df3d2e1383fb158yarl-1.11.1.tar.gz"
    sha256 "1bb2d9e212fb7449b8fb73bc461b51eaa17cc8430b4a87d87be7b25052d92f53"
  end

  def install
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin"vdirsyncer", "-v", "ERROR", "sync"]
    run_type :interval
    interval 60
    log_path var"logvdirsyncer.log"
    error_log_path var"logvdirsyncer.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath".configvdirsyncerconfig").write <<~EOS
      [general]
      status_path = "#{testpath}.vdirsyncerstatus"
      [pair contacts]
      a = "contacts_a"
      b = "contacts_b"
      collections = ["from a"]
      [storage contacts_a]
      type = "filesystem"
      path = "~.contactsa"
      fileext = ".vcf"
      [storage contacts_b]
      type = "filesystem"
      path = "~.contactsb"
      fileext = ".vcf"
    EOS
    (testpath".contactsafoo092a1e3b55.vcf").write <<~EOS
      BEGIN:VCARD
      VERSION:3.0
      EMAIL;TYPE=work:username@example.org
      FN:User Name Ö φ 風 ض
      UID:092a1e3b55
      N:Name;User
      END:VCARD
    EOS
    (testpath".contactsbfoo").mkpath
    system bin"vdirsyncer", "discover"
    system bin"vdirsyncer", "sync"
    assert_match "Ö φ 風 ض", (testpath".contactsbfoo092a1e3b55.vcf").read
  end
end