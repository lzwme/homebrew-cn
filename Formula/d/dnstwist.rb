class Dnstwist < Formula
  include Language::Python::Virtualenv

  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://files.pythonhosted.org/packages/e7/0e/88b4c5c7f3077c0d2e8544a14e321fce80b3cf0148a46dec9724e27c61d3/dnstwist-20250130.tar.gz"
  sha256 "8b6dd9c42a643a0e8b087903c0e6d75c0f6cebf94920ab0b7760ac2522c6bb42"
  license "Apache-2.0"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f72c9225a16821ffe223149d1580072ea30ab8e768aae7cda8158da6230a5bb"
    sha256 cellar: :any,                 arm64_sequoia: "986b1d10461fce557ccad6fcc65e8f59655ca5f17f2f38d362b61cceb531096a"
    sha256 cellar: :any,                 arm64_sonoma:  "30d703dbceb790b7074add95c09cc0741ac4809c4376c18ec7b069232be31bf2"
    sha256 cellar: :any,                 sonoma:        "bc467c1c9e26a8ee102e655ef3d12060722b4f61276f1c3c1d44348d724297c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4660f031d95c1e6433d771aa8f330fb80aca15a89392dcfc9e9842336e27888c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fcb696e3649b368c4c7723c19ce2e6ff036450accf9a8b0a1f9581005ab74b8"
  end

  depends_on "rust" => :build # for geoip2, uv-backend
  depends_on "certifi" => :no_linkage
  depends_on "libmaxminddb"
  depends_on "python@3.14"
  depends_on "ssdeep"

  uses_from_macos "libffi"

  on_linux do
    depends_on "whois"
  end

  pypi_packages package_name:     "dnstwist[full]",
                exclude_packages: "certifi"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/50/42/32cf8e7704ceb4481406eb87161349abb46a57fee3f008ba9cb610968646/aiohttp-3.13.3.tar.gz"
    sha256 "a949eee43d3782f2daae4f4a2819b2cb9b0c5d3b7f7a927067cc84dafdbb9f88"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "geoip2" do
    url "https://files.pythonhosted.org/packages/18/70/3d9e87289f79713aaf0fea9df4aa8e68776640fe59beb6299bb214610cfd/geoip2-5.2.0.tar.gz"
    sha256 "6c9ded1953f8eb16043ed0a8ea20e6e9524ea7b65eb745724e12490aca44ef00"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "maxminddb" do
    url "https://files.pythonhosted.org/packages/31/83/bcd7f2e7dfcf601258a4eab92155816218e8f8adf6608d5f7d39da7ba863/maxminddb-3.1.1.tar.gz"
    sha256 "b19a938c481518f19a2c534ffdcb3bc59582f0fbbdcf9f81ac9adf912a0af686"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "ppdeep" do
    url "https://files.pythonhosted.org/packages/ef/6c/4b97c7c1f7dcb4ee0c8d3534284e7f1a638dee6dccd5d0a8f7d9fa6dac3c/ppdeep-20260221.tar.gz"
    sha256 "8be1f4164b7ad2f7c40a51a664d3176701e40b2f9c1b96d18eeffaf06dfeff94"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "py-tlsh" do
    url "https://files.pythonhosted.org/packages/69/6b/94f9aee3904016a99d2cc9029ff9999f6058d8351e740730ad1a2bdba291/py_tlsh-4.12.1.tar.gz"
    sha256 "4b312d122c8a204d0b7ae7632c3b762160351887a19b5e451ef63da86dc231c1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "tld" do
    url "https://files.pythonhosted.org/packages/5c/5d/76b4383ac4e5b5e254e50c09807b3e13820bed6d6c11cd540264988d6802/tld-0.13.2.tar.gz"
    sha256 "d983fa92b9d717400742fca844e29d5e18271079c7bcfabf66d01b39b4a14345"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/23/6e/beb1beec874a72f23815c1434518bfc4ed2175065173fb138c3705f658d4/yarl-1.23.0.tar.gz"
    sha256 "53b1ea6ca88ebd4420379c330aea57e258408dd0df9af0992e5de2078dc9f5d5"
  end

  def install
    ENV["MAXMINDDB_USE_SYSTEM_LIBMAXMINDDB"] = "1"
    ENV.append "CPPFLAGS", "-I#{MacOS.sdk_path_if_needed}/usr/include/ffi" if OS.mac?

    venv = virtualenv_create(libexec, "python3.14")
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