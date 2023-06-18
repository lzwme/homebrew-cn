class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/22/25/e42c9be788883c94ed3a2bbaf37c2351cfe0d82cdb96676a629ed3adedec/nvchecker-2.12.tar.gz"
  sha256 "4200ddf733448c52309f110c6fa916727a7400f444855afa8ffe7ff1e5b0b6c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fa3a0add363b1a7491e722482424dbd96b133d42466a71f0afc021b2eef8551"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d0fe36aab3a200ccdde47a6296cee0634787447c3ed1eb38c340760a3a7f1c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d383fbb043ed1496fe153e3e2228c0fe40fd6037b2c65460f485360eb1434fb"
    sha256 cellar: :any_skip_relocation, ventura:        "a3c7a63a1c42c2132d432439649008188d43284c8fec3ca80bb08fe391e582c8"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b181828282012e3563126a61fe34ca02086adf6f7b5c082af1e5a443911d22"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9ad0b007650497ef3ff860b5184e4702742c4163d1e831979f85116b4e1ae5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dcd42039d8f12ec471b99f77914aca95b4854da57961033a9bd731175155629"
  end

  depends_on "jq" => :test
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d2/5d/29eed8861e07378ef46e956650615a9677f8f48df7911674f923236ced2b/platformdirs-3.5.3.tar.gz"
    sha256 "e48fabd87db8f3a7df7150a4a5ea22c546ee8bc39bc2473244730d4b56d2cc4e"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/a8/af/24d3acfa76b867dbd8f1166853c18eefc890fc5da03a48672b38ea77ddae/pycurl-7.45.2.tar.gz"
    sha256 "5730590be0271364a5bddd9e245c9cc0fb710c4cbacbdd95264a3122d23224ca"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/9e/c4/688d14600f3a8afa31816ac95220f2548648e292c3ff2262057aa51ac2fb/structlog-23.1.0.tar.gz"
    sha256 "270d681dd7d163c11ba500bc914b2472d2b50a8ef00faa999ded5ff83a2f906b"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/30/f0/6e5d85d422a26fd696a1f2613ab8119495c1ebb8f49e29f428d15daf79cc/tornado-6.3.2.tar.gz"
    sha256 "4b927c4f19b71e627b13f3db2324e4ae660527143f9e1f2e2fb404f3a187e2ba"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end