class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https:github.comelceefdnstwist"
  url "https:files.pythonhosted.orgpackages31a739d27816c945ba7ba78797fc7b6a726ce437dc12463c3ffadc192c5f563fdnstwist-20240116.tar.gz"
  sha256 "1468dba982fe14a1f322486102c33b96f0d78da4446313c455bcfe4fe98ee71b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0912fb64bf8667066e051416fac5d385cfe9d7feba2ced66754a921f41460889"
    sha256 cellar: :any,                 arm64_ventura:  "937410a27aae8e33a7753e04cc80207c0f468701145d87d88a249a102407fa38"
    sha256 cellar: :any,                 arm64_monterey: "de0126a55f01eed711c62e4bf11bb9239379668453e3269de07945cd0aeec1b7"
    sha256 cellar: :any,                 sonoma:         "5823f3a1993fb835e99b37fe9a7bb24f34bc45047caf7c939140e826c219942c"
    sha256 cellar: :any,                 ventura:        "aa7b1e88121df33d2fb4c0f193a6e7795ce3d5f45d395258bf0a8ad8bf21539e"
    sha256 cellar: :any,                 monterey:       "ebd14c3e29cdd80c96c1cbcbc8886414cc0cddb60abcf4d97f8ec9290f0ae102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "309987d71fcef9442aada61fa6a7bf825477512300baeafdce6215bdcb60d1f8"
  end

  depends_on "libmaxminddb"
  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  on_linux do
    depends_on "whois"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages54079467d3f8dae29b14f423b414d9e67512a76743c5bb7686fb05fe10c9cc3eaiohttp-3.9.1.tar.gz"
    sha256 "8fc49a87ac269d4529da45871e2ffb6874e87779c3d0e2ccd813c0899221239d"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages652d372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackagescf3d2102257e7acad73efc4a0c306ad3953f68c504c16982bbdfee3ad75d8085frozenlist-1.4.1.tar.gz"
    sha256 "c037a86e8513059a2613aaba4d817bb90b9d9b6b69aace3ce9c877e8c8ed402b"
  end

  resource "geoip2" do
    url "https:files.pythonhosted.orgpackagesa7ae892642e21881f95bdcb058580e74aaa3de0ee5ee4f76ccec02745f2a3abegeoip2-4.8.0.tar.gz"
    sha256 "dd9cc180b7d41724240ea481d5d539149e65b234f64282b231b9170794a9ac35"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "maxminddb" do
    url "https:files.pythonhosted.orgpackages0f07278a738306a26f5d43ad91e12ad16d9cdef6d1179f03f29df0cbae74be8bmaxminddb-2.5.2.tar.gz"
    sha256 "b3c33e4fc7821ee6c9f40837116e16ab6175863d4a64eee024c5bec686690a87"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages4a15bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "ppdeep" do
    url "https:files.pythonhosted.orgpackages64adca722788606970d227b1778c158d4a04ffd8190487fa80b3273e3fa587acppdeep-20200505.tar.gz"
    sha256 "acc74bb902e6d21b03d39aed740597093c6562185bfe06da9b5272e01c80a1ff"
  end

  resource "py-tlsh" do
    url "https:files.pythonhosted.orgpackagesba5b4d860cffd3e6e7afb277e159d97e11583fc3b611d22355799364dff325f1py-tlsh-4.7.2.tar.gz"
    sha256 "5b6943cfd93a168671f33b84828dca34d252278bdedcacf25cbe711fda655e9f"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "tld" do
    url "https:files.pythonhosted.orgpackages192b678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagese0adbedcdccbcbf91363fd425a948994f3340924145c2bc8ccb296f4a1e52c28yarl-1.9.4.tar.gz"
    sha256 "566db86717cf8080b99b58b083b773a908ae40f06681e87e589a976faf8246bf"
  end

  def install
    ENV["MAXMINDDB_USE_SYSTEM_LIBMAXMINDDB"] = "1"
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}usrincludeffi" if OS.mac?

    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources

    (libexec"bin").install "dnstwist.py" => "dnstwist"
    (bin"dnstwist").write_env_script libexec"bindnstwist", PATH: "#{libexec}bin:$PATH"
  end

  test do
    output = shell_output("#{bin}dnstwist --registered --lsh ssdeep brew.sh 2>&1")

    assert_match "brew.sh", output
    assert_match "NS:ns1.dnsimple.com", output
  end
end