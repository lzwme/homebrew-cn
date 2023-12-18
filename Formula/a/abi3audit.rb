class Abi3audit < Formula
  include Language::Python::Virtualenv

  desc "Scans Python packages for abi3 violations and inconsistencies"
  homepage "https:github.comtrailofbitsabi3audit"
  url "https:files.pythonhosted.orgpackagesa34d1f08c6db0b6cf02ef0fe33be39144d4477030910c3f61bffa3b2a9b09e87abi3audit-0.0.9.tar.gz"
  sha256 "4f469e146d911f238724d49fd280d8bb7f411ff5d224865b13e47d4132e776a6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "975f11fb62809ceb38d2380f4ec49d056b0ad5b3f31074ea174f21b92fae1217"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69af1583164604d24fb34794416fb53b5d55e00d829e2e24b32f153259b50d09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cdd917d31edfef5526ea8d568f1a938852028c025aeaa3e6ca8216d09c6288f"
    sha256 cellar: :any_skip_relocation, sonoma:         "78bb2ed3904bf719a5886b92d9c94fb72a2c24e1ac02561b840487dfdbe1f9be"
    sha256 cellar: :any_skip_relocation, ventura:        "d470bc62bd5c74b1ed36f2c50f054c0ee2071112730aa6eb133b42666fed4a01"
    sha256 cellar: :any_skip_relocation, monterey:       "5ce530d5ff454664fe4225dd672656d6bcbf608268a94bba4d5a168478444eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d660eb4c8bd0f87178886064529b69ef62faa142646570b25a700de7fbc1bc"
  end

  depends_on "cmake" => :build
  depends_on "pygments"
  depends_on "python-packaging"
  depends_on "python-platformdirs"
  depends_on "python-requests"
  depends_on "python-rich"
  depends_on "python@3.12"
  depends_on "six"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "rust" => :build
  end

  resource "abi3info" do
    url "https:files.pythonhosted.orgpackages4fd9366f6670b677f68c96cb06a5ab58c410be888bcb19bd39743e7e177db9d0abi3info-2023.10.22.tar.gz"
    sha256 "b02a11119d417e02e2e2ebb0adf247f6796fa19906d2c49926d207b22f19e3ef"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "cattrs" do
    url "https:files.pythonhosted.orgpackages91dc9e8bcf0ee80835cfc7da6d506ccc85ef6cb7a0ea924a61e029ba81093b1acattrs-23.2.2.tar.gz"
    sha256 "b790b1c2be1ce042611e33f740e343c2593918bbf3c1cc88cdddac4defc09655"
  end

  resource "kaitaistruct" do
    url "https:files.pythonhosted.orgpackages5404dd60b9cb65d580ef6cb6eaee975ad1bdd22d46a3f51b07a1e0606710ea88kaitaistruct-0.10.tar.gz"
    sha256 "a044dee29173d6afbacf27bcac39daf89b654dd418cfa009ab82d9178a9ae52a"
  end

  resource "pefile" do
    url "https:files.pythonhosted.orgpackages78c53b3c62223f72e2360737fd2a57c30e5b2adecd85e70276879609a7403334pefile-2023.2.7.tar.gz"
    sha256 "82e6114004b3d6911c77c3953e3838654b04511b8b66e8583db70c65998017dc"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages8405fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
  end

  resource "requests-cache" do
    url "https:files.pythonhosted.orgpackages4db624aeda90d94fb1fd2cd755d6ce176e526ef61d407f87fd77de6ab0d03157requests_cache-1.1.1.tar.gz"
    sha256 "764f93d3fa860be72125a568c2cc8eafb151cf29b4dc2515433a56ee657e1c60"
  end

  resource "url-normalize" do
    url "https:files.pythonhosted.orgpackagesecea780a38c99fef750897158c0afb83b979def3b379aaac28b31538d24c4e8furl-normalize-1.4.3.tar.gz"
    sha256 "d23d3a070ac52a67b83a1c59a0e68f8608d1cd538783b401bc9de2c0fac999b2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}abi3audit sip 2>&1", 1)
    assert_match(sip: \d+ extensions scanned; \d+ ABI version mismatches and \d+ ABI\s+violations found, output)
  end
end