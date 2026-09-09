class Beets < Formula
  include Language::Python::Virtualenv

  desc "Music library manager and tagger"
  homepage "https://beets.io/"
  url "https://files.pythonhosted.org/packages/b6/3b/359d68ce968214ffec8f55d9babe6de82794a846b5e02027f013456ef988/beets-2.14.0.tar.gz"
  sha256 "f412c9072ddc0bed04d843546a4222fcd24c9fe64cf233517ddcdb40190feea8"
  license "MIT"
  head "https://github.com/beetbox/beets.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "50f03f6a0720e452fb6aad43fa407b8e2b5e4337dfee9e5cfe2833b8f3c21ddc"
    sha256 cellar: :any, arm64_sequoia: "9eeaf54378dc36078175d800302c674f328244b1ada108a2978f05617e891e2b"
    sha256 cellar: :any, arm64_sonoma:  "e3e31e52ffba674202e8e84cd58b3f507430550be3d18a248d7bea1b89b76c35"
    sha256 cellar: :any, arm64_linux:   "0e61b7cd8745b16d9fda96ab4adf6ba86ed548b63b2ef1a424e175af33fded90"
    sha256 cellar: :any, x86_64_linux:  "6454d6b02d1fb84f0ecd5f5c20127557c7a0e0f1007fa8638194426afb62e87a"
  end

  depends_on "cython" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build # for jellyfish
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi numpy]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "confuse" do
    url "https://files.pythonhosted.org/packages/98/45/3ad821336a7953a2322e7e2d062488cfe179748725e5165117151b88a121/confuse-2.2.1.tar.gz"
    sha256 "8e7600c3261852122eb5f17b24b06ab8e5437b21d6224853c1420c38ac469d3c"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "jellyfish" do
    url "https://files.pythonhosted.org/packages/0b/14/fc5bdb637996df181e5c4fa3b15dcc27d33215e6c41753564ae453bdb40f/jellyfish-1.2.1.tar.gz"
    sha256 "72d2fda61b23babe862018729be73c8b0dc12e3e6601f36f6e65d905e249f4db"
  end

  resource "lap" do
    url "https://files.pythonhosted.org/packages/f1/ae/5cc637c2e5158b7dcf1a9744d33b11dfc21d9309931169402f573e4d1ee3/lap-0.5.13.tar.gz"
    sha256 "9eff7169e3ca452995af0493cc20d35452c4bfd06122c36c06457119ffbd411b"
  end

  resource "mediafile" do
    url "https://files.pythonhosted.org/packages/e3/02/460b31c20833036d8f171b991ff2f46c7f1dc85c6219e8bf7efca4a9aa5a/mediafile-0.17.0.tar.gz"
    sha256 "80c9003fd25d7096a7237e3b58e6ff018ef67f9c39900feafacabac1742c7d3a"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/df/70/1675da133ea92227da41bf5b24e1c66be597ff736a1533ade41da986852f/mutagen-1.48.1.tar.gz"
    sha256 "8f95637ab9f6f305cec6bd1294e197debe207998e3e068596563c74f86b0a173"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/69/b7/802a56eca9f2fac455b8bab5375a2647b0f0e14a2cd63ef077de3c4a7658/platformdirs-4.11.7.tar.gz"
    sha256 "4f41487eeeeeb07f3a6625e61d9bc0ae6809f92d3386dbd74392fbb76108104d"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/62/43/48693393af06b9fffbaea6bb8fe03be3c3f17be5d1423dab347d1aad1dde/pyrate_limiter-4.5.0.tar.gz"
    sha256 "098345fff3a52b84dee9bcf6973f184c8b3ef8d34e1f4f781ac0773e3984598b"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-ratelimiter" do
    url "https://files.pythonhosted.org/packages/3a/71/aecc6307695ddad2d11f474cd79d79b111ee90dd123d697b76eaa1cd73a1/requests_ratelimiter-0.10.0.tar.gz"
    sha256 "9c1a78d7646caa5ccf211a6c341abd16d329be2c8c35044a418aa9da7c0e7a33"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?
    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages(python3)

    without = ["lap"]
    venv = virtualenv_install_with_resources(without:)

    # Install these without build isolation to avoid building another `numpy`
    without.each { |r| venv.pip_install resource(r), build_isolation: false }
  end

  test do
    (testpath/"config.yaml").write <<~YAML
      directory: #{testpath}/music
      library: #{testpath}/library.db
      import:
        copy: no
        move: no
        quiet: yes
    YAML

    ENV["BEETSDIR"] = testpath.to_s

    system bin/"beet", "import", "-A", "-q", test_fixtures("test.mp3")
    assert_match "Tracks: 1", shell_output("#{bin}/beet stats")
  end
end