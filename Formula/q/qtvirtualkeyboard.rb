class Qtvirtualkeyboard < Formula
  desc "Provides an input framework and reference keyboard frontend"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtvirtualkeyboard-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtvirtualkeyboard-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtvirtualkeyboard-everywhere-src-6.12.0.tar.xz"
  sha256 "2aae3628f4648f86959d7853e7e1f50ee96a7f1bb5497afb62b7deff6c350170"
  license all_of: [
    "GPL-3.0-only",
    "Apache-2.0",   # bundled openwnn, pinyin and tcime
    "BSD-3-Clause", # bundled tcime; *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtvirtualkeyboard.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "649c2c45427475a6edadc0bad1d7723f1b5cef78eba80e1aa9d5e29dbcafc590"
    sha256 cellar: :any, arm64_tahoe:       "49fbdf71fd5120d45f1749d6a43a6fdd9a4d014f33739ba36914d437bc5a93de"
    sha256 cellar: :any, arm64_sequoia:     "e60cbc00e3f45b431701185e8992fa458c773f7f03550df139d299c2a7d51e3a"
    sha256 cellar: :any, arm64_linux:       "1614a74abf6361bbde0edb19286ee7e98e6db53228b4e03e800e506ad87e7cbb"
    sha256 cellar: :any, x86_64_linux:      "a6b887d5ad40336ae9211ad584f0c9c0970dbc4a502893aa263b5a924eccf09b"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "hunspell"
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtmultimedia"
  depends_on "qtsvg"

  def install
    rm_r("src/plugins/hunspell/3rdparty/hunspell")

    args = %W[
      -DCMAKE_STAGING_PREFIX=#{prefix}
      -DFEATURE_system_hunspell=ON
    ]
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
      import QtQuick
      import QtQuick.Window
      import QtQuick.VirtualKeyboard

      Window {
        visible: true
        width: 640
        height: 480
        id: root

        InputPanel {
          id: inputPanel
          anchors.bottom: parent.bottom
          width: root.width
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