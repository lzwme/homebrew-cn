class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://files.pythonhosted.org/packages/dc/7e/e473c19e6a885cdebfd6c6d18fcdb4c1f00d9caf17d72112a366023628e9/dnstwist-20230509.tar.gz"
  sha256 "153f1f833d456dff8a70b622f13a5699af392782415d69fc38dd26f98eb4740c"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02d60ac57f0ad6547ee6cbdb65db261779098450ed772495f963aeafe16506fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0c0bf7d74fae3d1c8237e60782533b4b24fae2abf9b8a4ce431cf552f72c671"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f8cdcc2dbd73945c15001cbc4da0ccdd54bdf702b7ca833b147214b10ccefa8"
    sha256 cellar: :any_skip_relocation, ventura:        "c8bd97cf6b54d50444452ebcc09178bfd079b9f086619bd5ed779ed034e0ca43"
    sha256 cellar: :any_skip_relocation, monterey:       "9ac47adc1626c9a0ffb6dba22baa0203c1b69d3aad00967d9bc88c2259a8881b"
    sha256 cellar: :any_skip_relocation, big_sur:        "342d25379777e0b08bd426f521fe5381782a9cc0b27e0f542b41e8969764a6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49ecc49010f864a3361ce15e0c2bdd7f84d08dc86f9e35475a8ddd4b69d65e5d"
  end

  depends_on "geoip"
  depends_on "python@3.11"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  on_linux do
    depends_on "whois"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/d6/12/6fc7c7dcc84e263940e87cbafca17c1ef28f39dae6c0b10f51e4ccc764ee/aiohttp-3.8.5.tar.gz"
    sha256 "b9552ec52cc147dbf1944ac7ac98af7602e51ea2dcd076ed194ca3c0d1c7d0bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/28/99/2dfd53fd55ce9838e6ff2d4dac20ce58263798bd1a0dbe18b3a9af3fcfce/anyio-3.7.1.tar.gz"
    sha256 "44a3c9aba0f5defa43261a8b3efb97891f2bd7d804e0e1f56419befa1adfc780"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/bd/5f/45f60fd7b03a1bef883a0eb4f9b6465628c1977393be45802eef1962571d/dnspython-2.4.0.tar.gz"
    sha256 "758e691dbb454d5ccf4e1b154a19e52847f79e21a42fef17b969144af29a4e6c"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "geoip2" do
    url "https://files.pythonhosted.org/packages/9b/cc/4d544e59233664aca348053d2343ffdc878a5f851a7f6896fc2b7d5a63f6/geoip2-4.7.0.tar.gz"
    sha256 "3bdde4994f6bc917eafab5b51e772d737b2ae00037a5b85001fb06dc68f779df"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/63/ad/c98ecdbfe04417e71e143bf2f2fb29128e4787d78d1cedba21bd250c7e7a/httpcore-0.17.3.tar.gz"
    sha256 "a6f30213335e34c1ade7be6ec7c47f19f50c56db36abef1a9dfa3815b1cb3888"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/fe/06/31078febc8852d673b33602e096e87671eac7b7a6b737b0be563f8c2ac23/maxminddb-2.4.0.tar.gz"
    sha256 "81e54e53408bd502650e5969ccba16780af659ec1db1c44b2c997e4330a5ed96"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "ppdeep" do
    url "https://files.pythonhosted.org/packages/64/ad/ca722788606970d227b1778c158d4a04ffd8190487fa80b3273e3fa587ac/ppdeep-20200505.tar.gz"
    sha256 "acc74bb902e6d21b03d39aed740597093c6562185bfe06da9b5272e01c80a1ff"
  end

  resource "py-tlsh" do
    url "https://files.pythonhosted.org/packages/ba/5b/4d860cffd3e6e7afb277e159d97e11583fc3b611d22355799364dff325f1/py-tlsh-4.7.2.tar.gz"
    sha256 "5b6943cfd93a168671f33b84828dca34d252278bdedcacf25cbe711fda655e9f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  resource "whois" do
    url "https://files.pythonhosted.org/packages/dd/46/d94f5de31d0a2eb53df836ac950acb99299f6665cde87ae3dd526a02ff76/whois-0.9.27.tar.gz"
    sha256 "57a2c3edce163b0313849d4014005111a315090f69f56918f93addd570302f45"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi"

    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources

    (libexec/"bin").install "dnstwist.py" => "dnstwist"
    (bin/"dnstwist").write_env_script libexec/"bin/dnstwist", PATH: "#{libexec}/bin:$PATH"
  end

  test do
    output = shell_output("#{bin}/dnstwist --registered --lsh ssdeep brew.sh 2>&1")

    assert_match "brew.sh", output
    assert_match "NS:ns1.dnsimple.com", output
  end
end