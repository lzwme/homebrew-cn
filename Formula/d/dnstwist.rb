class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https:github.comelceefdnstwist"
  url "https:files.pythonhosted.orgpackages31a739d27816c945ba7ba78797fc7b6a726ce437dc12463c3ffadc192c5f563fdnstwist-20240116.tar.gz"
  sha256 "1468dba982fe14a1f322486102c33b96f0d78da4446313c455bcfe4fe98ee71b"
  license "Apache-2.0"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "93822d03ad69743fd767903de1e0211ed885c068da9fb007c6c6340ee1ba2139"
    sha256 cellar: :any,                 arm64_ventura:  "1f279ce557f244c2c1159b85fb80db61e36192fd4dc10e045db5972598793a32"
    sha256 cellar: :any,                 arm64_monterey: "312e3b6eaf0299f107da4ea8d2cb98a40807fc0fc9bd25100942d0b2284ea92c"
    sha256 cellar: :any,                 sonoma:         "4d2c0e61cae070f42c16e0a2b58747f62dd7856bb47ae5e5c37d39bb2242f682"
    sha256 cellar: :any,                 ventura:        "aeb0a888683ee5e3a69c66df328d2ad7570a894819f1025a47014cf4cdf34662"
    sha256 cellar: :any,                 monterey:       "6f27e022b0d64fee671fba9ab62d9562a3e105a38207d3083434889bae0aa081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc89167e17fd42f6496631713ed0f989c02c911050aec95f3a1d7e5c22cf170"
  end

  depends_on "certifi"
  depends_on "libmaxminddb"
  depends_on "python@3.12"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  on_linux do
    depends_on "whois"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackagesb7c3112f2f992aeb321de483754c1c5acab08c8ac3388c9c7e6f3e4f45ec1c42aiohappyeyeballs-2.3.5.tar.gz"
    sha256 "6fa48b9f1317254f122a07a131a86b71ca6946ca989ce6326fff54a99a920105"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages451136ba898823ab19e49e6bd791d75b9185eadef45a46fc00d3c669824df8a0aiohttp-3.10.2.tar.gz"
    sha256 "4d1f694b5d6e459352e5e925a42e05bac66655bfde44d81c59992463d2897014"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesae670952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32faiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dnspython" do
    url "https:files.pythonhosted.orgpackages377dc871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
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
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "maxminddb" do
    url "https:files.pythonhosted.orgpackages9f9e7806bf76d917182a4f4a08325f66eee6f32fe1123398789ba2547b5d3f3emaxminddb-2.6.2.tar.gz"
    sha256 "7d842d32e2620abc894b7d79a5a1007a69df2c6cf279a06b94c9c3913f66f264"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesf979722ca999a3a09a63b35aac12ec27dfa8e5bb3a38b0f857f7a1a209a88836multidict-6.0.5.tar.gz"
    sha256 "f7e301075edaf50500f0b341543c41194d8df3ae5caf4702f2095f3ca73dd8da"
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
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages5e11487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1dsetuptools-72.1.0.tar.gz"
    sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  end

  resource "tld" do
    url "https:files.pythonhosted.orgpackages192b678082222bc1d2823ea8384c6806085b85226ff73885c703fe0c7143ef64tld-0.13.tar.gz"
    sha256 "93dde5e1c04bdf1844976eae440706379d21f4ab235b73c05d7483e074fb5629"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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