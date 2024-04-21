class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https:www.riverbankcomputing.comsoftwarepyqtintro"
  url "https:files.pythonhosted.orgpackages8c2b6fe0409501798abc780a70cab48c39599742ab5a8168e682107eaab78fcaPyQt6-6.6.1.tar.gz"
  sha256 "9f158aa29d205142c56f0f35d07784b8df0be28378d20a97bcda8bd64ffd0379"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e3f74e8411e07172f5553bdafc137b6e58adebdc4399854de81831021c45056c"
    sha256 cellar: :any,                 arm64_ventura:  "a0f2ea7aa99cd0ef8ef1c9c43883179e2b3969d905d363b041824ff2ada59a4c"
    sha256 cellar: :any,                 arm64_monterey: "e1575fd00ba11cbf6f27d1d8037656d4c0987f19a69f5960e7d84d88ccd95684"
    sha256 cellar: :any,                 sonoma:         "1a22dd2ff55dd10d82a085992036c2216528d72d47f1af5a1011dad82a9357db"
    sha256 cellar: :any,                 ventura:        "348a454bf27b8de335a8d2272709cdbd2792787c76b796dae3baa7f6ce316d59"
    sha256 cellar: :any,                 monterey:       "4f25ba87939aaf9520911755f29b7190bd287e6ac3825e076ef775c64a8b417a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0ab80ba9fa1be909117e468a0e99edb6e8f47e43de8f50a5262494225541892"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip" => :build
  depends_on "python@3.12"
  depends_on "qt"

  fails_with gcc: "5"

  # extra components
  resource "pyqt6-3d" do
    url "https:files.pythonhosted.orgpackages3c3f7909d2886f500b9512a544c46c4e3e213a7624229a1dd1f417b885dedd6ePyQt6_3D-6.6.0.tar.gz"
    sha256 "372b206eb8185f2b6ff048629d3296cb137c9e5901b113119ffa46a317726988"
  end

  resource "pyqt6-charts" do
    url "https:files.pythonhosted.orgpackagesef7e88d25f0c34a795744d8b87d0bdb5c76ce0e28f4070568e763442973c3e2cPyQt6_Charts-6.6.0.tar.gz"
    sha256 "14cc6e5d19cae80129524a42fa6332d0d5dada4282a9423425e6b9ae1b6bc56d"
  end

  resource "pyqt6-datavisualization" do
    url "https:files.pythonhosted.orgpackagese1ca8b4a4ba040ecfa4fa0859ee8dcb99095f19c4ca5e42255821c9a6feafde8PyQt6_DataVisualization-6.6.0.tar.gz"
    sha256 "5ad62a0f9815eca3acdff1078cfc2c10f6542c1d5cfe53626c0015e854441479"
  end

  resource "pyqt6-networkauth" do
    url "https:files.pythonhosted.orgpackagesc4dbb4a4ec7c0566b247410a0371a91050592b76480ca7581ebeb2c537f4596bPyQt6_NetworkAuth-6.6.0.tar.gz"
    sha256 "cdfc0bfaea16a9e09f075bdafefb996aa9fdec392052ba4fb3cbac233c1958fb"
  end

  resource "pyqt6-sip" do
    url "https:files.pythonhosted.orgpackages9823e54e02a44afc357ccab1b88575b90729664164358ceffde43e4f2e549daaPyQt6_sip-13.6.0.tar.gz"
    sha256 "2486e1588071943d4f6657ba09096dc9fffd2322ad2c30041e78ea3f037b5778"
  end

  resource "pyqt6-webengine" do
    url "https:files.pythonhosted.orgpackages499a69db3a2ab1ba43f762144a66f0375540e195e107a1049d7263ab48ebc9ccPyQt6_WebEngine-6.6.0.tar.gz"
    sha256 "d50b984c3f85e409e692b156132721522d4e8cf9b6c25e0cf927eea2dfb39487"
  end

  # Backport support for `qt` 6.7.0 API changes
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches50173dde32f39f63617ece5d4cad2a616027a506pyqtqt-6.7.0.patch"
    sha256 "2e1df66b5d6ad338269368bc3778f27ed77f66be891613f7c567fbdac2197f6d"
  end

  def python3
    "python3.12"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}qtplugins'"

    site_packages = prefixLanguage::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system "sip-install", *args

    resource("pyqt6-sip").stage do
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end

    resources.each do |r|
      next if r.name == "pyqt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "pyqt6-webengine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]",
          "[tool.sip.project]\nsip-include-dirs = [\"#{site_packages}PyQt#{version.major}bindings\"]\n"
        system "sip-install", "--target-dir", site_packages
      end
    end
  end

  test do
    system bin"pyuic#{version.major}", "-V"
    system bin"pylupdate#{version.major}", "-V"

    system python3, "-c", "import PyQt#{version.major}"
    pyqt_modules = %w[
      3DAnimation
      3DCore
      3DExtras
      3DInput
      3DLogic
      3DRender
      Gui
      Multimedia
      Network
      NetworkAuth
      Positioning
      Quick
      Svg
      Widgets
      Xml
    ]
    # Don't test WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
    pyqt_modules << "WebEngineCore" if OS.linux? || DevelopmentTools.clang_build_version > 1200
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end