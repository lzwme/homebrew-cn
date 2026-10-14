class Qtwebview < Formula
  desc "Displays web content in a QML application"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtwebview-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtwebview-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtwebview-everywhere-src-6.12.0.tar.xz"
  sha256 "bee0642225614d7fc9486a2ca6db7d2c82a28c311404d1503185a360792c504e"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtwebview.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e02f36790976cef4b0bdce2b5cfdc6148eef017f39ea3772cd3f74be59b76714"
    sha256 cellar: :any, arm64_tahoe:       "98d5b9c98f8ae934e853dde839ba82bace112b7a34739d84bcdfa5a7214f498e"
    sha256 cellar: :any, arm64_sequoia:     "58732ceb9551bc274913054077d573df0d98ebea8a0a2cf2323ffe93c02c7214"
    sha256 cellar: :any, arm64_linux:       "0669bce5224977445c2908e1ba4cbd225fb06ef623726b4e267968ae2cd06f01"
    sha256 cellar: :any, x86_64_linux:      "bec172c549909782a5176cbc1b853c3433fae0eea08b59b4d96da2c74950fafc"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtwebengine"

  on_macos do
    depends_on "qtpositioning"
    depends_on "qtwebchannel"
  end

  allow_network_access! :test

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?
    args << "-DQT_NO_PACKAGE_VERSION_CHECK=TRUE" # TODO: remove once QtWebEngine 6.140.0 is available

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"test.qml").write <<~QML
      import QtQml
      import QtQuick
      import QtWebView

      Item {
        WebView {
          anchors.fill: parent
          url: "https://brew.sh/"
        }
        Timer {
          interval: 2000
          running: true
          onTriggered: Qt.quit()
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system formula_opt_bin("qtdeclarative")/"qml", "test.qml"
  end
end