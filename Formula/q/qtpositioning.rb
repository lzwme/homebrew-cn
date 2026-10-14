class Qtpositioning < Formula
  desc "Provides access to position, satellite info and area monitoring classes"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtpositioning-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtpositioning-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtpositioning-everywhere-src-6.12.0.tar.xz"
  sha256 "b060d410fac7413b05a0e7938bbf3325f7ad08d7df14af3956270f0696e76763"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # bundled poly2tri; *.cmake
    "BSL-1.0",      # bundled clipper
    "MIT",          # bundled clip2tri
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtpositioning.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "72e5d9efa1150706ed93d5274a3f97a00120ef523e11daadb86554fb9c1f6c07"
    sha256 cellar: :any, arm64_tahoe:       "6590f79ba4ad96ee8502cb7263b7103405038797a0cb597bdf87613c9d653d37"
    sha256 cellar: :any, arm64_sequoia:     "5c87ad2518b73ee16f96497fa97e43b20ac64dcd8b9fc4f0f5a4f80cf6be69c4"
    sha256 cellar: :any, arm64_linux:       "a6f53d9c9f2c9e4ffbc99e0f4b0b19b2b515a7b8e45ad5b2cf8b1029dac567fc"
    sha256 cellar: :any, x86_64_linux:      "6d75f4a34d8f1390fa332308ffdd35dde11db64fea9067bc9a46ac8d38c4ecbf"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtserialport"

  conflicts_with "qt@5", because: "both link conflicting binaries"

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
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS Positioning)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::Positioning)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += positioning
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QGeoPositionInfoSource>

      int main(void) {
        Q_ASSERT(QGeoPositionInfoSource::availableSources().contains("nmea"));
        return 0;
      }
    CPP

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "cmake"
    system "cmake", "--build", "cmake"
    system "./cmake/test"

    ENV.delete "CPATH" if OS.mac?
    mkdir "qmake" do
      system formula_opt_bin("qtbase")/"qmake", testpath/"test.pro"
      system "make"
      system "./test"
    end

    flags = shell_output("pkgconf --cflags --libs Qt6Positioning").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end