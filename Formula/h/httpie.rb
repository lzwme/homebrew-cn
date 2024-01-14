class Httpie < Formula
  include Language::Python::Virtualenv

  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https:httpie.io"
  url "https:github.comhttpiecliarchiverefstags3.2.2.tar.gz"
  sha256 "01b4407202fac3cc68c73a8ff1f4a81a759d9575fabfad855772c29365fe18e6"
  license "BSD-3-Clause"
  revision 4
  head "https:github.comhttpiecli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ae4a2c5109376610ce7113a92898c9a72e2a377fa8207742b43edad54fab845"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d363d506c5db2190ed9b47b564dd210cf4b46a6acf429964ba83b4da2f382256"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60c21496e1e58d581aaff12364c87ab65ad5d967f8ecdee20143c1e5997d1fd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "11b1c55aa654dda7d95036225c127c757f3f6a04f6ba0fa1d4b930d6f2258069"
    sha256 cellar: :any_skip_relocation, ventura:        "7b9dbfab1797b996b5e8b60cab04485b534c6c8f3d44ddc66b8c2f892742c4fd"
    sha256 cellar: :any_skip_relocation, monterey:       "53e4a10d50f1178ff1cbb8d8064bb913f98294962e698611a72bdb62cfd0378c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21b503294e029136dd6aec1d942e7dc3e7481d969630ae093e4df3be8f812d82"
  end

  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages4a15bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "pysocks" do
    url "https:files.pythonhosted.orgpackagesbd11293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https:files.pythonhosted.orgpackagesf361d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bbrequests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesfcc9b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    # We use a special file called __build_channel__.py to denote which source
    # was used to install httpie.
    File.write("httpieinternal__build_channel__.py", "BUILD_CHANNEL = \"homebrew\"")

    virtualenv_install_with_resources

    man1.install_symlink libexec"sharemanman1http.1"
    man1.install_symlink libexec"sharemanman1https.1"
    man1.install_symlink libexec"sharemanman1httpie.1"

    bash_completion.install "extrashttpie-completion.bash" => "httpie"
    fish_completion.install "extrashttpie-completion.fish" => "httpie.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}httpie --version")
    assert_match version.to_s, shell_output("#{bin}https --version")
    assert_match version.to_s, shell_output("#{bin}http --version")

    raw_url = "https:raw.githubusercontent.comHomebrewhomebrew-coreHEADFormulahhttpie.rb"
    assert_match "PYTHONPATH", shell_output("#{bin}http --ignore-stdin #{raw_url}")
  end
end