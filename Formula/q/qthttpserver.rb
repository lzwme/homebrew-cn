class Qthttpserver < Formula
  desc "Framework for embedding an HTTP server into a Qt application"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qthttpserver-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qthttpserver-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qthttpserver-everywhere-src-6.12.0.tar.xz"
  sha256 "ede040264551d0930ea5f6c1a4c18a7a3dea59d635e71cd2e81f02567d7814a4"
  license all_of: [
    "GPL-3.0-only",
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qthttpserver.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5cd6d053b5b9519455bb3a77959e697f4dc2337ad7c8d7fffd17fe56153b9d09"
    sha256 cellar: :any, arm64_tahoe:       "32ae7509cc9a60f76d40d9d25761b88847e4c3c967f560f16be5f3fe33ba09c9"
    sha256 cellar: :any, arm64_sequoia:     "acf6095fbb23bfbdac234384aaa82a88cb8be092a5ed88707f3ebb2f2ab4c59f"
    sha256 cellar: :any, arm64_linux:       "4540c5a250715a336eee659486cd9d65dbf4f3e7677e242f76acad649c08cd8a"
    sha256 cellar: :any, x86_64_linux:      "96abca1495061cf6eed27892aba3f6a018576760fe9bed0e70941290d4ccfb8b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"
  depends_on "qtwebsockets"

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
      find_package(Qt6 REQUIRED COMPONENTS HttpServer)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::HttpServer)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += httpserver
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #undef QT_NO_DEBUG
      #include <QtHttpServer>

      int main(void) {
        QHttpServer httpServer;
        httpServer.route("/", []() { return "Hello world"; });
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

    flags = shell_output("pkgconf --cflags --libs Qt6HttpServer").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end