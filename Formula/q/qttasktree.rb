class Qttasktree < Formula
  desc "General purpose library for asynchronous task execution"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qttasktree-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qttasktree-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qttasktree-everywhere-src-6.12.0.tar.xz"
  sha256 "d28cac0d1fc2d87fbc8fd70d4f956a79b2d37a039df2766e9ff0f69635596b5e"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  head "https://code.qt.io/qt/qttasktree.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eea54fe1170043b8366ba1aa3a1e0cd243cb5c9aa3aa64c07582e7434e4014e7"
    sha256 cellar: :any, arm64_tahoe:       "ffa26cfc43970c25439e1e364bc2bc30f3b39dc8fd22b47e60fe4bd4826ebc44"
    sha256 cellar: :any, arm64_sequoia:     "c365e79a041d93944cf082d0445812c680268ad68d064e0da9511c6074ef900e"
    sha256 cellar: :any, arm64_linux:       "d36307c7f8e035760e5406a80f798b83ff2db4f1293e618db7c53805de1b53dc"
    sha256 cellar: :any, x86_64_linux:      "e933df07722918bb0e66133ef87db92c4dddb200eacc946401da727f6014e2a7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "qtbase"

  def install
    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/auto/threadfunction/tst_qthreadfunction.cpp"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(tst_qthreadfunction LANGUAGES CXX)
      set(QT_NO_APPLE_SDK_AND_XCODE_CHECK ON)
      find_package(Qt6BuildInternals REQUIRED COMPONENTS STANDALONE_TEST)

      qt_internal_add_test(tst_qthreadfunction
        SOURCES
          #{pkgshare}/tst_qthreadfunction.cpp
        LIBRARIES
          Qt::TaskTree
      )
    CMAKE

    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "cmake", "-S", ".", "-B", "."
    system "cmake", "--build", "."
    system "./tst_qthreadfunction"
  end
end