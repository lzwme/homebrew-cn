class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://files.pythonhosted.org/packages/ef/84/a1474ae1ec3ef3af0bbe6ee3bf6253570265835be8b3969301e07606481c/dnstwist-20230918.tar.gz"
  sha256 "ce065ab14abf0aa58f9a9fa0960feed494e64f2b524c573f0d5c2d5993731ac3"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea19313243bfc48a6541cc206b69431b01aec479dbe31ecc350e8f0121f8edbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "071406fa124d47eb99565b4234d01e62b07419a6122140d2727a48b8f44176f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e797add2a6c25c1e5bd193a3d8ccf500a35f58f437ea5c0bf4c301bfe5580ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa56af93874c76d696869fe167213a38447de036fcba8ac6d1fd684c96a3e24c"
    sha256 cellar: :any_skip_relocation, ventura:        "b561c0b606f4b491a2df2475204e9e59a3beccbf6e317a247c2d57715212c2fa"
    sha256 cellar: :any_skip_relocation, monterey:       "663c7756fb5cc5e0912d95d58e3a49358b73a88df580d9ce7fa2448bd013e546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fb3db74b34d3e3cbe4a56fd095081441e4a3fdffa2f4e4b7960eef6111de1eb"
  end

  depends_on "geoip"
  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  on_linux do
    depends_on "whois"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/c4/50/a717a133bda2efc27efbf8a65398c925b6d0605213da0db6929627ccb758/aiohttp-3.9.0b0.tar.gz"
    sha256 "cecc64fd7bae6debdf43437e3c83183c40d4f4d86486946f412c113960598eee"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/87/d6/21b30a550dafea84b1b8eee21b5e23fa16d010ae006011221f33dcd8d7f8/async-timeout-4.0.3.tar.gz"
    sha256 "4640d96be84d82d02ed59ea2b7105a0f7b33abe8703703cd0ab0bf87c427522f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8c/1f/49c96ccc87127682ba900b092863ef7c20302a2144b3185412a08480ca22/frozenlist-1.4.0.tar.gz"
    sha256 "09163bdf0b2907454042edb19f887c6d33806adc71fbd54afc14908bfdc22251"
  end

  resource "geoip2" do
    url "https://files.pythonhosted.org/packages/9b/cc/4d544e59233664aca348053d2343ffdc878a5f851a7f6896fc2b7d5a63f6/geoip2-4.7.0.tar.gz"
    sha256 "3bdde4994f6bc917eafab5b51e772d737b2ae00037a5b85001fb06dc68f779df"
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

  resource "tld" do
    url "https://files.pythonhosted.org/packages/19/2b/678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64/tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/5f/3f/04b3c5e57844fb9c034b09c5cb6d2b43de5d64a093c30529fd233e16cf09/yarl-1.9.2.tar.gz"
    sha256 "04ab9d4b9f587c06d801c2abfe9317b77cdf996c65a90d5e84ecc45010823571"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi"

    venv = virtualenv_create(libexec, "python3.12")
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