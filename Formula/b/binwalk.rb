class Binwalk < Formula
  include Language::Python::Virtualenv

  desc "Searches a binary image for embedded files and executable code"
  homepage "https:github.comReFirmLabsbinwalk"
  url "https:github.comReFirmLabsbinwalkarchiverefstagsv2.3.4.tar.gz"
  sha256 "60416bfec2390cec76742ce942737df3e6585c933c2467932f59c21e002ba7a9"
  license "MIT"
  revision 1
  head "https:github.comReFirmLabsbinwalk.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46b1b92e433f1eccc60ffd7827709216295d89fe432f4306d3504f76bee9d7cb"
    sha256 cellar: :any,                 arm64_ventura:  "fb3ae65b71ec3712d069066db3e295d266767da3ccc55a100fa7a115b42252fd"
    sha256 cellar: :any,                 arm64_monterey: "77ce813cbdcb4be28efc6e88c1f6110313c14ad5cb86ecb79f8d5e70a9b6b7ca"
    sha256 cellar: :any,                 sonoma:         "897918a5bc55d11807274a23d0347a6744ba07c4062a4a4b80df5cac8b2f05fb"
    sha256 cellar: :any,                 ventura:        "02d98de992b3b565be46950793f4b92bf97eca061a9c9e9d8d370fc07106b104"
    sha256 cellar: :any,                 monterey:       "baadf957ef0ef1c5e11acb9844d98ca912bf52d363dd1bfc1d3f3897fcd374ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0984e5e3f5c0b31708758457d94811e20801a042dc8e3b36c20279d75b1cbc54"
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
    url "https:files.pythonhosted.orgpackagesdde59adc30ebca9009d5ad36c7e74462ee5fc51985ca9a845fd26f9f5c99b3dffonttools-4.47.0.tar.gz"
    sha256 "ec13a10715eef0e031858c1c23bfaee6cba02b97558e4a7bfa089dba4a8c2ebf"
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
    url "https:files.pythonhosted.orgpackagesfbab38a0e94cb01dacb50f06957c2bed1c83b8f9dac6618988a37b2487862944matplotlib-3.8.2.tar.gz"
    sha256 "01a978b871b881ee76017152f1f1a0cbf6bd5f7b8ff8c96df0df1bd57d8755a1"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackagesb13842a8855ff1bf568c61ca6557e2203f318fb7afeadaf2eb8ecfdbde107151pycryptodome-3.19.1.tar.gz"
    sha256 "8ae0dd1bcfada451c35f9e29a3e5db385caabc190f98e4a80ad02a61098fb776"
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