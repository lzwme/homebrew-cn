class PyqtAT5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/4d/5d/b8b6e26956ec113ad3f566e02abd12ac3a56b103fcc7e0735e27ee4a1df3/PyQt5-5.15.10.tar.gz"
  sha256 "d46b7804b1b10a4ff91753f8113e5b5580d2b4462f3226288e2d84497334898a"
  license "GPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "d71f9eb4c4207f5cd514c6164daa25b214bbc59bed4fe7ac2d35dd19d8e38541"
    sha256 cellar: :any,                 arm64_ventura:  "e965b99dc455b9da26f80c554a65d20db7d0ea70cf7cde8406d01b115652ce32"
    sha256 cellar: :any,                 arm64_monterey: "5e5212557dd94ee07e1f2cff48b6e8192c2d520f0894b20547484da25c36443c"
    sha256 cellar: :any,                 sonoma:         "60bb1b52d94f88b11780754972ca3f6683f85972316400334a631ccf227e47ff"
    sha256 cellar: :any,                 ventura:        "8346e9e65779fbb8e8730e9adbc430c6db8d236fd783a8eaa17b2229ae489bbd"
    sha256 cellar: :any,                 monterey:       "2275f56241aa386f84f0f80a5ffedf046cca0ea451f113abbb2210e51b35386c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdfc3b92cfdbaa09dc589c893df7ec191318a2047790bb3a08b097f0fa8e0e90"
  end

  depends_on "pyqt-builder" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "python@3.12"
  depends_on "qt@5"

  fails_with gcc: "5"

  # extra components
  resource "pyqt3d" do
    url "https://files.pythonhosted.org/packages/a5/80/26e3394c25187854bd3b68865b2b46cfd285aae01bbf448ddcac6f466af0/PyQt3D-5.15.6.tar.gz"
    sha256 "7d6c6d55cd8fc221b313c995c0f8729a377114926f0377f8e9011d45ebf3881c"
  end

  resource "pyqt5-sip" do
    url "https://files.pythonhosted.org/packages/ee/81/fce2a475aa56c1f49707d9306b930695b6ff078c2242c9f2fd72a3214e1f/PyQt5_sip-12.13.0.tar.gz"
    sha256 "7f321daf84b9c9dbca61b80e1ef37bdaffc0e93312edae2cd7da25b953971d91"
  end

  resource "pyqtchart" do
    url "https://files.pythonhosted.org/packages/eb/17/1d9bb859b3e09a06633264ad91249ede0abd68c1e3f2f948ae7df94702d3/PyQtChart-5.15.6.tar.gz"
    sha256 "2691796fe92a294a617592a5c5c35e785dc91f7759def9eb22da79df63762339"
  end

  resource "pyqtdatavisualization" do
    url "https://files.pythonhosted.org/packages/9c/ff/6ba767b4e1dbc32c7ffb93cd5d657048f6a4edf318c5b8810c8931a1733b/PyQtDataVisualization-5.15.5.tar.gz"
    sha256 "8927f8f7aa70857ef00c51e3dfbf6f83dd9f3855f416e0d531592761cbb9dc7f"
  end

  resource "pyqtnetworkauth" do
    url "https://files.pythonhosted.org/packages/85/b6/6b8f30ebd7c15ded3d91ed8d6082dee8aebaf79c4e8d5af77b1172c805c2/PyQtNetworkAuth-5.15.5.tar.gz"
    sha256 "2230b6f56f4c9ad2e88bf5ac648e2f3bee9cd757550de0fb98fe0bcb31217b16"
  end

  resource "pyqtpurchasing" do
    url "https://files.pythonhosted.org/packages/41/2a/354f0ae3fa02708719e2ed6a8c310da4283bf9a589e2a7fcf7dadb9638af/PyQtPurchasing-5.15.5.tar.gz"
    sha256 "8bb1df553ba6a615f8ec3d9b9c5270db3e15e831a6161773dabfdc1a7afe4834"
  end

  resource "pyqtwebengine" do
    url "https://files.pythonhosted.org/packages/cf/4b/ca01d875eff114ba5221ce9311912fbbc142b7bb4cbc4435e04f4f1f73cb/PyQtWebEngine-5.15.6.tar.gz"
    sha256 "ae241ef2a61c782939c58b52c2aea53ad99b30f3934c8358d5e0a6ebb3fd0721"
  end

  def python3
    "python3.12"
  end

  def install
    site_packages = prefix/Language::Python.site_packages(python3)
    args = [
      "--target-dir", site_packages,
      "--scripts-dir", bin,
      "--confirm-license",
      "--no-designer-plugin",
      "--no-qml-plugin"
    ]
    system "sip-install", *args

    resource("pyqt5-sip").stage do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end

    resources.each do |r|
      next if r.name == "pyqt5-sip"

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]", <<~EOS
          [tool.sip.project]
          sip-include-dirs = ["#{site_packages}/PyQt#{version.major}/bindings"]
        EOS
        system "sip-install", "--target-dir", site_packages
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "--version"
    system bin/"pylupdate#{version.major}", "-version"

    components = %w[
      Gui
      Location
      Multimedia
      Network
      Quick
      Svg
      WebEngineWidgets
      Widgets
      Xml
    ]

    system python3, "-c", "import PyQt#{version.major}"
    components.each { |mod| system python3, "-c", "import PyQt5.Qt#{mod}" }
  end
end