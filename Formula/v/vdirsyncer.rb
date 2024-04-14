class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https:github.compimutilsvdirsyncer"
  url "https:files.pythonhosted.orgpackages81fb6fbb7f1d102a59db275811a0de756d6f5bb55c624ba4bdf918b3fbd2ddc0vdirsyncer-0.19.2.tar.gz"
  sha256 "fd058ceeab8293459a0466cd9b0e4ab3b39462c6e089a0f0ac37c307420d82ba"
  license "BSD-3-Clause"
  revision 6
  head "https:github.compimutilsvdirsyncer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e10f1fb6b59f6e7b2c758b37d517601cd10964b00721f90f8c739a94c98e4c55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a39669cb5216f3f70d0667bfa9fc6d0d17e4037db2de16d10fa9bcc8f4bd172"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e34cc5c34510804944f731f40c2a0c35c56f665e7e91a96b32ae2e15461fbbd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b64501aa9cea6bfaaa48e5b30996aa09aafb92046b027a9541dd84341da479d6"
    sha256 cellar: :any_skip_relocation, ventura:        "52aef6fe3958f605a71e387b4e948b42f9569726f145afdedd81a1dc709fd232"
    sha256 cellar: :any_skip_relocation, monterey:       "b839575c9b57461eee75e2617bef505998240126fb7c0f7f013857159effd857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aa117a4ed02615605ab76cc9e3c6820e9ddfcbda478d329e15cbab4532e31a4"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages7e0b4235b25496c741f4c9f75a94951fbc15c48537349a03448687fb226256efaiohttp-3.9.4.tar.gz"
    sha256 "6ff71ede6d9a5a58cfb7b6fffc83ab5d4a63138276c771ac91ceaaddf5459644"
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
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
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
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
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
    system "#{bin}vdirsyncer", "discover"
    system "#{bin}vdirsyncer", "sync"
    assert_match "Ö φ 風 ض", (testpath".contactsbfoo092a1e3b55.vcf").read
  end
end