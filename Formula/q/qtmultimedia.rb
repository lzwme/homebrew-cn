class Qtmultimedia < Formula
  desc "Provides APIs for playing back and recording audiovisual content"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtmultimedia-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtmultimedia-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtmultimedia-everywhere-src-6.12.0.tar.xz"
  sha256 "3143f53b64257ba2a0685c940f5dce476c75871ff86b516de45cfd54ea93a62d"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    { all_of: ["MPL-2.0", "BSD-3-Clause"] }, # bundled eigen
    "Apache-2.0",   # bundled resonance-audio
    "BSD-3-Clause", # bundled pffft; *.cmake
    "GPL-3.0-only", # Qt6MultimediaTestLib
    "MIT",          # bundled signalsmith-stretch (Linux)
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtmultimedia.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5360f6abcb3e5c4afcddc0f8d0bb3d503ae3cd5593621da30eb9b97d8e8ac8aa"
    sha256 cellar: :any, arm64_tahoe:       "c2b1662131ebf71f7e9bd32cfe8dc0d94bf1893d416d8ad3508ec6ff6018b506"
    sha256 cellar: :any, arm64_sequoia:     "feb9f54ba089493a413976792bbaf5dc0be8ae8f984e66b2b6ab7abc2209b075"
    sha256 cellar: :any, arm64_linux:       "733c32f50cbf171427b55610c5e4cb594ca08a218df3bb828aecc0f49c0b42ee"
    sha256 cellar: :any, x86_64_linux:      "51e13587df534a6e93d2e96aa8aaa41cfdfccb572c4f4940857860142cd38c3a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "qtshadertools" => :build
  depends_on "vulkan-headers" => :build
  depends_on "pkgconf" => :test
  depends_on "qtbase"
  depends_on "qtdeclarative"
  depends_on "qtquick3d"

  on_macos do
    depends_on macos: :ventura
    depends_on "qtshadertools"
  end

  on_ventura do
    depends_on xcode: ["15.0", :build] # for `@available(macOS 14)`
  end

  on_linux do
    depends_on "ffmpeg"
    depends_on "glib"
    depends_on "gstreamer"
    depends_on "libva"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "pipewire"
    depends_on "pulseaudio"
  end

  conflicts_with "qt@5", because: "both link conflicting binaries"

  def install
    # Allow -march options to be passed through, as Qt builds
    # arch-specific code with runtime detection of capabilities:
    # https://bugreports.qt.io/browse/QTBUG-113391
    ENV.runtime_cpu_detection

    args = ["-DCMAKE_STAGING_PREFIX=#{prefix}"]
    if OS.mac?
      args << "-DQT_FEATURE_ffmpeg=OFF"
      args << "-DQT_NO_APPLE_SDK_AND_XCODE_CHECK=ON"
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX, find_framework: "FIRST")
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Some config scripts will only find Qt in a "Frameworks" folder
    frameworks.install_symlink lib.glob("*.framework") if OS.mac?
  end

  test do
    modules = %w[Core Multimedia]

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test VERSION 1.0.0 LANGUAGES CXX)
      find_package(Qt6 REQUIRED COMPONENTS #{modules.join(" ")})
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::#{modules.join(" Qt6::")})
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += #{modules.join(" ").downcase}
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~CPP
      #include <QCoreApplication>
      #include <QAudioDevice>
      #include <QMediaDevices>
      #include <QTextStream>

      int main(int argc, char *argv[]) {
        QCoreApplication app(argc, argv);
        QTextStream out(stdout);
        for(const QAudioDevice &device : QMediaDevices::audioInputs()) {
          out << "ID: " << device.id() << Qt::endl;
        }
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

    flags = shell_output("pkgconf --cflags --libs Qt6#{modules.join(" Qt6")}").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end