class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/28/01/9e4b91cb0c1023934b1dc654c5bbfc29cbabcbf6092f936b74aee46dd637/PyQt6-6.5.0.tar.gz"
  sha256 "b97cb4be9b2c8997904ea668cf3b0a4ae5822196f7792590d05ecde6216a9fbc"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "0cdb6cb5278faddfb8850c6a6de69399a79d8141c66d31e7bd0184e029f82246"
    sha256 cellar: :any, arm64_monterey: "3fbe8f97d2c4ff9f2f0b783a9c72ea81c3955420ac39ea93676b9e06292d46d0"
    sha256 cellar: :any, arm64_big_sur:  "987025a408f3740814de0fc4404dcb13799934b895feab148d11408f29b0c07d"
    sha256 cellar: :any, ventura:        "c730f857ce574e739a8b9c8ee47e5e319abdf249728353aef8a0b2aa302a84cf"
    sha256 cellar: :any, monterey:       "1de92092c26ef30b3bcdb1ebbb0c4e8457f9a310eedaeec1a975f077afb82641"
    sha256 cellar: :any, big_sur:        "18ca50a5a59408977677ec13e151ce6840c773b6e013abca481ca55d7ce0d8db"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  depends_on "python@3.11"
  depends_on "qt"

  fails_with gcc: "5"

  # extra components
  resource "PyQt6-3D" do
    url "https://files.pythonhosted.org/packages/61/3d/3c2fc89e929138d42face65a0ad2b81ad0f2df9701d8fd74ad591a2eaa28/PyQt6_3D-6.5.0.tar.gz"
    sha256 "f8ef3e2965a518367eb4cc693fd9f23698fcbeb909c7dcb7269737b8d877f68b"
  end

  resource "PyQt6-Charts" do
    url "https://files.pythonhosted.org/packages/d7/da/aef92577bb1d0679cc4f47218c89e6875c5a3e515f32db33a738f95dac06/PyQt6_Charts-6.5.0.tar.gz"
    sha256 "6ff00f65b2517f99bf106ddd28c76f3ca344f91ecf5ba68191e20a2d90024962"
  end

  resource "PyQt6-DataVisualization" do
    url "https://files.pythonhosted.org/packages/57/95/8086e46fdae5d5c8714e64c6c9f09c09e34eb85464199374ce1e39175174/PyQt6_DataVisualization-6.5.0.tar.gz"
    sha256 "19b949abcc315b1fa9293ba5b8b66bbf694d2d3f84585edc78167473328df212"
  end

  resource "PyQt6-NetworkAuth" do
    url "https://files.pythonhosted.org/packages/dc/7f/2305cdafa48a14cf8f81a75f5d840277cf860cf4cec7afdb9d23d183ebe4/PyQt6_NetworkAuth-6.5.0.tar.gz"
    sha256 "7170db3f99e13aef855d9d52a00a8baa2dea92d12f9b441fed9c6dec57f83e09"
  end

  resource "PyQt6-sip" do
    url "https://files.pythonhosted.org/packages/23/fd/530e274c4d7d39645478156063de266d7d3c1fb70ba9f38372a75094ed51/PyQt6_sip-13.5.0.tar.gz"
    sha256 "61c702b7f81796a27c294ba76f1cba3408161f06deb801373c42670ed36f722a"
  end

  resource "PyQt6-WebEngine" do
    url "https://files.pythonhosted.org/packages/8d/dd/90d73f7b51f5bdc733341e317a9ac1f0d8fdf61d6c793061d429ae86e28f/PyQt6_WebEngine-6.5.0.tar.gz"
    sha256 "8ba9db56c4c181a2a2fab1673ca35e5b63dc69113f085027ddc43c710b6d6ee9"
  end

  def python3
    "python3.11"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system "sip-install", *args

    resource("PyQt6-sip").stage do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end

    resources.each do |r|
      next if r.name == "PyQt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "PyQt6-WebEngine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]",
          "[tool.sip.project]\nsip-include-dirs = [\"#{site_packages}/PyQt#{version.major}/bindings\"]\n"
        system "sip-install", "--target-dir", site_packages
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
    pyqt_modules << "WebEngineCore" if OS.linux? || DevelopmentTools.clang_build_version > 1200
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end