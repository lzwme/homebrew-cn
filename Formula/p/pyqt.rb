class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/ce/bf/ff284a136b39cb1873c18e4fca4a40a8847c84a1910c5fb38c6a77868968/pyqt6-6.8.1.tar.gz"
  sha256 "91d937d6166274fafd70f4dee11a8da6dbfdb0da53de05f5d62361ddf775e256"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "cbe45d094564fea92c0847da804ff4ec0cd8dcb7a110a455e07c7ebb8c6727f6"
    sha256 cellar: :any,                 arm64_ventura: "f1906c6edfe3d0524e644214388d96e66a47e7c6b2547fc71e17c09d4c58d319"
    sha256 cellar: :any,                 sonoma:        "8110d8e9a389bd66361fa0a3b13af4777ca39c010c2112cdd65e61cb6962f4fd"
    sha256 cellar: :any,                 ventura:       "54f3da525162caaee221593e014ee8c48d70bc7419844c5f6106c9a85cd76ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "456712d70a2606cd236b813ef73851f9d041b80e2bd50791637fc28153635d38"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python@3.13"
  depends_on "qt"

  # extra components
  resource "pyqt6-3d" do
    url "https://files.pythonhosted.org/packages/13/15/4eef4a5087e4af01638baee8fd1c22e97fce2eb593e73c7f1cf9f59dffa9/PyQt6_3D-6.8.0.tar.gz"
    sha256 "f62790a787cfc99fcd84c774fa952b83c877dd2175355a3a6609d37fe1a1c7a3"
  end

  resource "pyqt6-charts" do
    url "https://files.pythonhosted.org/packages/94/51/d37e1527dcf0e2bf5bfdba4200c2297a4224e299d79c4d4cfbe1a363e01b/PyQt6_Charts-6.8.0.tar.gz"
    sha256 "f86705b8740e3041667ce211aeaa205b750eb6baf4c908f4e3f6dc8c720d10f1"
  end

  resource "pyqt6-datavisualization" do
    url "https://files.pythonhosted.org/packages/3c/26/9006f1ff80fe800df3ea1b6f26bf61323e19acede5a3e55a115908638689/PyQt6_DataVisualization-6.8.0.tar.gz"
    sha256 "822a94163b8177b9dd507988aff4da7c79ce26bc47fc5f9780dea6989c531171"
  end

  resource "pyqt6-networkauth" do
    url "https://files.pythonhosted.org/packages/ee/79/3d67110608e7e6b55c501359699826dd861c21c668ccc9a8fbc99bfc528b/PyQt6_NetworkAuth-6.8.0.tar.gz"
    sha256 "2a1043ff6d03fc19e7bc87fad4f32d4d7e56d2bf1bb89b2a43287c0161457d59"
  end

  resource "pyqt6-sip" do
    url "https://files.pythonhosted.org/packages/90/18/0405c54acba0c8e276dd6f0601890e6e735198218d031a6646104870fe22/pyqt6_sip-13.10.0.tar.gz"
    sha256 "d6daa95a0bd315d9ec523b549e0ce97455f61ded65d5eafecd83ed2aa4ae5350"
  end

  resource "pyqt6-webengine" do
    url "https://files.pythonhosted.org/packages/cd/c8/cadaa950eaf97f29e48c435e274ea5a81c051e745a3e2f5d9d994b7a6cda/PyQt6_WebEngine-6.8.0.tar.gz"
    sha256 "64045ea622b6a41882c2b18f55ae9714b8660acff06a54e910eb72822c2f3ff2"

    # Apply Arch Linux patch to fix build
    patch do
      url "https://gitlab.archlinux.org/archlinux/packaging/packages/pyqt6-webengine/-/raw/85846264bbfd2628fae66786e2f48ae40fddadca/fix-build.patch"
      sha256 "14b523cf26fd6e066ed1900fd59e1e6f8d7abc5900a04fc5b9bc9f3cb831045f"
    end
  end

  # Apply Arch Linux patch to fix build with Qt 6.9
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/pyqt6/-/raw/5a29c7c906d26b5d952ed76e57b83519cb5aa1a0/qt-6.9.patch"
    sha256 "f69d5c5e6b1bc1eaa3aa08f205b55ac38bc38b9326b6875c77de65b5e58d05d9"
  end

  def python3
    "python3.13"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    sip_install = Formula["pyqt-builder"].opt_libexec/"bin/sip-install"
    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system sip_install, *args

    resource("pyqt6-sip").stage do
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end

    resources.each do |r|
      next if r.name == "pyqt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "pyqt6-webengine" && OS.mac? && MacOS.version <= :ventura

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]", <<~TOML
          [tool.sip.project]
          sip-include-dirs = ["#{site_packages}/PyQt#{version.major}/bindings"]
        TOML
        system sip_install, "--target-dir", site_packages, "--verbose"
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

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
    pyqt_modules << "WebEngineCore" if OS.linux? || MacOS.version > :ventura
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }

    # Make sure plugin is installed as it currently gets skipped on wheel build,  e.g. `pip install`
    assert_path_exists share/"qt/plugins/designer"/shared_library("libpyqt#{version.major}")
  end
end