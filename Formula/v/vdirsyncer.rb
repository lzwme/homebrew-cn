class Vdirsyncer < Formula
  include Language::Python::Virtualenv

  desc "Synchronize calendars and contacts"
  homepage "https:github.compimutilsvdirsyncer"
  url "https:files.pythonhosted.orgpackages81fb6fbb7f1d102a59db275811a0de756d6f5bb55c624ba4bdf918b3fbd2ddc0vdirsyncer-0.19.2.tar.gz"
  sha256 "fd058ceeab8293459a0466cd9b0e4ab3b39462c6e089a0f0ac37c307420d82ba"
  license "BSD-3-Clause"
  revision 4
  head "https:github.compimutilsvdirsyncer.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44909d30bf0cf91d434ef13c48196e8509a074b1112d58bbeef95f889cd766ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d33daac76addb4378b2f1f324b55baee3e2f0850b91b290d2cb371c00549cac7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54cf40be7e4e02afc4017cc95c0e25cf77dbe8785669d7b9110d5342ec467fea"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ce55e721e9ed47ffe3c344e12b6afe99affeee66884cc5589e7cba5c721c550"
    sha256 cellar: :any_skip_relocation, ventura:        "3809e48e61336abe6aa14905e053bd9e06d72f5280a13ff50451233cd315302b"
    sha256 cellar: :any_skip_relocation, monterey:       "8505cc99c4b51d9e1c2e75b7f54525d21a5025c685db629c17cf7e89bcb76c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8458243e897fab735399e9f688cdb7017caf7d89c24016b2fc331c49fa55a9a4"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python@3.12"

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages718068f3bd93240efd92e9397947301efb76461db48c5ac80be2423ffa9c20a3aiohttp-3.9.0.tar.gz"
    sha256 "09f23292d29135025e19e8ff4f0a68df078fe4ee013bca0105b2e803989de92d"
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
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click-log" do
    url "https:files.pythonhosted.orgpackages3232228be4f971e4bd556c33d52a22682bfe318ffe57a1ddb7a546f347a90260click-log-0.4.0.tar.gz"
    sha256 "3970f8570ac54491237bcdb3d8ab5e3eef6c057df29f8c3d1151a51a9c23b975"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8c1f49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages4a15bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
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
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages5f3f04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
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