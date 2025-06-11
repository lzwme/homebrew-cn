class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https:github.comelceefdnstwist"
  url "https:files.pythonhosted.orgpackagese70e88b4c5c7f3077c0d2e8544a14e321fce80b3cf0148a46dec9724e27c61d3dnstwist-20250130.tar.gz"
  sha256 "8b6dd9c42a643a0e8b087903c0e6d75c0f6cebf94920ab0b7760ac2522c6bb42"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "366ec0adb71ee84d67b89ce4d469f92dbba2f294b1f71f29753277a0343ac268"
    sha256 cellar: :any,                 arm64_sonoma:  "374f1f149942aebe8e890ec038fce6eda557ec6bc5b7cb4f80e8eee6a59e1c52"
    sha256 cellar: :any,                 arm64_ventura: "bbf0f1c3f9d1807e96192517840f29949ed4425b27f9aa58cd76bf3d3dcce258"
    sha256 cellar: :any,                 sonoma:        "9f9253f3532aa49a25693021147fcfb3cfb05a9ba1eae15213de94aaa3525bde"
    sha256 cellar: :any,                 ventura:       "789e566f70252c9351cbf04916ede41eb7457a06af724c6f471e292cf71108d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31ab6f3c78135a30ee41c3e739bad5a83ad608077a430ae5925af24844798437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0ea91569f0cc5fa1da1ec0292e8ac946afd4cf258d56aec68a7cce4db6c2940"
  end

  depends_on "certifi"
  depends_on "libmaxminddb"
  depends_on "python@3.13"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  on_linux do
    depends_on "whois"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesf284ea27e6ad14747d8c51afe201fb88a5c8282b6278256d30a6f71f730add88aiohttp-3.12.12.tar.gz"
    sha256 "05875595d2483d96cb61fa9f64e75262d7ac6251a7e3c811d8e26f7d721760bd"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackagesb54a263763cb2ba3816dd94b08ad3a33d5fdae34ecb856678773cc40a3605829dnspython-2.7.0.tar.gz"
    sha256 "ce9c432eda0dc91cf618a5cedf1a4e142651196bbcd2c80e89ed5a907e5cfaf1"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages79b1b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "geoip2" do
    url "https:files.pythonhosted.orgpackages0f5f902835f485d1c423aca9097a0e91925d6a706049f64e678ec781b168734dgeoip2-5.1.0.tar.gz"
    sha256 "ee3f87f0ce9325eb6484fe18cbd9771a03d0a2bad1dd156fa3584fafa562d39a"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "maxminddb" do
    url "https:files.pythonhosted.orgpackagesd1107a7cf5219b74b19ea1834b43256e114564e8a845f447446ac821e1b9951emaxminddb-2.7.0.tar.gz"
    sha256 "23a715ed3b3aed07adae4beeed06c51fd582137b5ae13d3c6e5ca4890f70ebbf"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages912fa3470242707058fe856fe59241eee5635d79087100b7042a867368863a27multidict-6.4.4.tar.gz"
    sha256 "69ee9e6ba214b5245031b76233dd95408a0fd57fdb019ddcc1ead4790932a8e8"
  end

  resource "ppdeep" do
    url "https:files.pythonhosted.orgpackages64adca722788606970d227b1778c158d4a04ffd8190487fa80b3273e3fa587acppdeep-20200505.tar.gz"
    sha256 "acc74bb902e6d21b03d39aed740597093c6562185bfe06da9b5272e01c80a1ff"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa61643264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "py-tlsh" do
    url "https:files.pythonhosted.orgpackagesba5b4d860cffd3e6e7afb277e159d97e11583fc3b611d22355799364dff325f1py-tlsh-4.7.2.tar.gz"
    sha256 "5b6943cfd93a168671f33b84828dca34d252278bdedcacf25cbe711fda655e9f"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "tld" do
    url "https:files.pythonhosted.orgpackagesdfa15723b07a70c1841a80afc9ac572fdf53488306848d844cd70519391b0d26tld-0.13.1.tar.gz"
    sha256 "75ec00936cbcf564f67361c41713363440b6c4ef0f0c1592b5b0fbe72c17a350"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages3cfbefaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  def install
    ENV["MAXMINDDB_USE_SYSTEM_LIBMAXMINDDB"] = "1"
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}usrincludeffi" if OS.mac?

    venv = virtualenv_create(libexec, "python3.13")
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