class Qtlottie < Formula
  desc "Display graphics and animations exported by the Bodymovin plugin"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtlottie-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtlottie-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtlottie-everywhere-src-6.12.0.tar.xz"
  sha256 "6b8f04c917f2666f8cca4e7804bcabb6edffe151406b89fb28de3bba5a5d997e"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtlottie.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f4d2269cf7366c3db64c48bc2de2349e711695679e02f93c61d3c1c4698a3164"
    sha256 cellar: :any, arm64_tahoe:       "3b7af01e392056e40594446fa2ad375b985f3b0bb88274630008a0a5da4526c3"
    sha256 cellar: :any, arm64_sequoia:     "54c36ec8c568cdc1e13abe1c718cb936589598eb71869b97e53f20633c7b63d8"
    sha256 cellar: :any, arm64_linux:       "070891135e4a10ad825a65f60a1102926633ab968ebc9f2938c6da6bf2d98d08"
    sha256 cellar: :any, x86_64_linux:      "1d4fe4f122c1ed62f5061ed71e212dcace11f3d600dbe5ac385d8fc4a35ceaa3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquicktimeline"

  resource "rect_rotate.json", :test do
    url "https://ghfast.top/https://raw.githubusercontent.com/qt/qtlottie/888fb0ca5d5e18fe5d8b88ed721544bf204ac158/tests/manual/testApp/rect_rotate.json"
    sha256 "d0d5d2b036c04d4b2c1211d062fe1c123053ea0d4639cd33a2cec724236bf328"
  end

  allow_network_access! :test

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    testpath.install resource("rect_rotate.json")

    # Based on https://github.com/qt/qtlottie/blob/dev/tests/manual/testApp/main.qml
    (testpath/"test.qml").write <<~QML
      import QtQuick
      import QtQuick.Window
      import Qt.labs.lottieqt

      Window {
        visible: true
        width: animContainer.width
        height: animContainer.height
        title: qsTr("Animation test")
        color: "black"

        Item {
          id: animContainer
          width: childrenRect.width
          height: childrenRect.height

          LottieAnimation {
            id: bmAnim
            quality: LottieAnimation.MediumQuality
            source: "rect_rotate.json"
            onFinished: Qt.quit()
          }
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system formula_opt_bin("qtdeclarative")/"qml", "test.qml"
  end
end