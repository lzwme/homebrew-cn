class Binwalk < Formula
  include Language::Python::Virtualenv

  desc "Searches a binary image for embedded files and executable code"
  homepage "https:github.comReFirmLabsbinwalk"
  url "https:github.comReFirmLabsbinwalkarchiverefstagsv2.3.4.tar.gz"
  sha256 "60416bfec2390cec76742ce942737df3e6585c933c2467932f59c21e002ba7a9"
  license "MIT"
  head "https:github.comReFirmLabsbinwalk.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "aba55d1d9857149f60db5e976b54571a1e77a6bed589e286fb703700283f96d8"
    sha256 cellar: :any,                 arm64_ventura:  "d4d418ba303811db090a5aed12d82c696c88476f69600338aaacdcbec888a321"
    sha256 cellar: :any,                 arm64_monterey: "76c0a9c8bf1e3c480dd3bb3e3bfe20af3dc432fe65598e47df5c40a513747565"
    sha256 cellar: :any,                 sonoma:         "80f791198442d659000941676ed6192195f20ecba6f5ffcc38dac42e40f5fc35"
    sha256 cellar: :any,                 ventura:        "53c36bc90dbbf038f7687f142e49388b98d526dc47079b100397c40e1c65fb61"
    sha256 cellar: :any,                 monterey:       "992e87b0d998e8092716e17fc72fd044442c1d2bef7a0158efab6bb41d0352b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108cabc9ef40c01d49e866e7619a6b6ad6207abb11ccb3360861653d15f20a10"
  end

  depends_on "meson" => :build # for contourpy
  depends_on "meson-python" => :build # for contourpy
  depends_on "ninja" => :build # for contourpy
  depends_on "pkg-config" => :build
  depends_on "pybind11" => :build # for contourpy and matplotlib
  depends_on "swig" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "p7zip"
  depends_on "pillow"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-pyparsing"
  depends_on "python@3.11" # Python 3.12 issue: https:github.comReFirmLabsbinwalkissues507
  depends_on "qhull"
  depends_on "six"
  depends_on "ssdeep"
  depends_on "xz"

  resource "capstone" do
    url "https:files.pythonhosted.orgpackages7afee6cdc4ad6e0d9603fa662d1ccba6301c0cb762a1c90a42c7146a538c24e9capstone-5.0.1.tar.gz"
    sha256 "740afacc29861db591316beefe30df382c4da08dcb0345a0d10f0cac4f8b1ee2"
  end

  resource "contourpy" do
    url "https:files.pythonhosted.orgpackages11a348ddc7ae832b000952cf4be64452381d150a41a2299c2eb19237168528d1contourpy-1.2.0.tar.gz"
    sha256 "171f311cb758de7da13fc53af221ae47a5877be5a0843a9fe150818c51ed276a"
  end

  resource "cycler" do
    url "https:files.pythonhosted.orgpackagesa995a3dbbb5028f35eafb79008e7522a75244477d2838f38cbb722248dabc2a8cycler-0.12.1.tar.gz"
    sha256 "88bb128f02ba341da8ef447245a9e138fae777f6a23943da4540077d3601eb1c"
  end

  resource "fonttools" do
    url "https:files.pythonhosted.orgpackagesc49f9c3c66017e2be1aa04d9ae54936c932b1e3ad09f70987a9b8a9a2c71ccaafonttools-4.44.3.tar.gz"
    sha256 "f77b6c0add23a3f1ec8eda40015bcb8e92796f7d06a074de102a31c7d007c05b"
  end

  resource "gnupg" do
    url "https:files.pythonhosted.orgpackages966c21f99b450d2f0821ff35343b9a7843b71e98de35192454606435c72991a8gnupg-2.3.1.tar.gz"
    sha256 "8db5a05c369dbc231dab4c98515ce828f2dffdc14f1534441a6c59b71c6d2031"
  end

  resource "kiwisolver" do
    url "https:files.pythonhosted.orgpackagesb92d226779e405724344fc678fcc025b812587617ea1a48b9442628b688e85eakiwisolver-1.4.5.tar.gz"
    sha256 "e57e563a57fb22a142da34f38acc2fc1a5c864bc29ca1517a88abc963e60d6ec"
  end

  resource "matplotlib" do
    url "https:files.pythonhosted.orgpackagesb41b1b80fcc6b7f33a4c7fa025e944416f8b63fa8d278fad32470c82a2edf319matplotlib-3.8.1.tar.gz"
    sha256 "044df81c1f6f3a8e52d70c4cfcb44e77ea9632a10929932870dfaa90de94365d"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages1a72acc37a491b95849b51a2cced64df62aaff6a5c82d26aca10bc99dbda025bpycryptodome-3.19.0.tar.gz"
    sha256 "bc35d463222cdb4dbebd35e0784155c81e161b9284e567e7e933d722e533331e"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages4cc413b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  def install
    # `matplotlib` needs extra inputs to use system libraries.
    # Ref: https:github.commatplotlibmatplotlibblobv3.8.1docdeveldependencies.rst#use-system-libraries
    # TODO: Update build to use `--config-settings=setup-args=...` when `matplotlib` switches to `meson-python`.
    ENV["MPLSETUPCFG"] = buildpath"mplsetup.cfg"
    (buildpath"mplsetup.cfg").write <<~EOS
      [libs]
      system_freetype = true
      system_qhull = true
    EOS

    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resource("kiwisolver") # needs `cppy` to build so keep build isolation
    # We disable build isolation to make use of existing Homebrew formulae rather
    # than rebuilding Python packages like `numpy` that are used by build-backend.
    venv.pip_install(resources.reject { |r| r.name == "kiwisolver" }, build_isolation: false)
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    touch "binwalk.test"
    system "#{bin}binwalk", "binwalk.test"
  end
end