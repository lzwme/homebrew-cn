class Qtquicktimeline < Formula
  desc "Enables keyframe-based animations and parameterization"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtquicktimeline-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtquicktimeline-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtquicktimeline-everywhere-src-6.12.0.tar.xz"
  sha256 "6919153c841478c113f0ad20526f40e606590968334762ec6ccbc96002f8da19"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtquicktimeline.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "53b25fa6dc13127561a3bfd910dd9bf28b77898b2b11f44f01a77d931c18c00d"
    sha256 cellar: :any, arm64_tahoe:       "223b501a5c82c4c995a8cbab0c224fe1c21e7e2e6fbdae4faf612030b7abd52a"
    sha256 cellar: :any, arm64_sequoia:     "61747d337bd1fc584f6e551ce8fbb48161149fad2029953e672aaeb0af6ac2af"
    sha256 cellar: :any, arm64_linux:       "570812fab067fd681283266c27a9ffcabbfec643f74f9ea5c5d5e321e3026b61"
    sha256 cellar: :any, x86_64_linux:      "e0faf8ddb1b372f5dd51ac5a3557b751ce38542f6d46b12d57c07eed075e3690"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "qtbase"
  depends_on "qtdeclarative"

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
    (testpath/"test.qml").write <<~QML
      import QtQuick 2.0
      import QtQuick.Timeline 1.0

      Item {
        Timeline {
          id: timeline
          startFrame: 0
          endFrame: 100
          enabled: true
          animations: [
            TimelineAnimation {
              duration: 1000
              from: 0
              to: 100
              running: true
              onRunningChanged: { if(!running) { Qt.quit() } }
            }
          ]
          KeyframeGroup {
            target: rectangle
            property: "color"
            Keyframe { frame: 0; value: "red" }
            Keyframe { frame: 100; value: "blue" }
          }
        }
        Rectangle {
          id: rectangle
          width: 50
          height: 50
          color: "red"
        }
      }
    QML

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal"
    system formula_opt_bin("qtdeclarative")/"qml", "test.qml"
  end
end