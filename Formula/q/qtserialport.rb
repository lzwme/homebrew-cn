class Qtserialport < Formula
  desc "Provides classes to interact with hardware and virtual serial ports"
  homepage "https://www.qt.io/"
  url "https://download.qt.io/official_releases/qt/6.12/6.12.0/submodules/qtserialport-everywhere-src-6.12.0.tar.xz"
  mirror "https://qt.mirror.constant.com/archive/qt/6.12/6.12.0/submodules/qtserialport-everywhere-src-6.12.0.tar.xz"
  mirror "https://mirrors.ukfast.co.uk/sites/qt.io/archive/qt/6.12/6.12.0/submodules/qtserialport-everywhere-src-6.12.0.tar.xz"
  sha256 "ba8886a54eee466e57c9fa1341255cc09c462c84baab3ee7b19d67cdbcbd71c3"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only", "GPL-3.0-only"] },
    "BSD-3-Clause", # *.cmake
  ]
  compatibility_version 1
  head "https://code.qt.io/qt/qtserialport.git", branch: "dev"

  livecheck do
    formula "qtbase"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "88380548ee0932994ce17d314d306d9acc18ad3092d1bbc527ce7706a7b4e3ae"
    sha256 cellar: :any, arm64_tahoe:       "e57a8afb5c96109a67043eb0b982c8ceae877be82a9c84382fe1f7103e53baca"
    sha256 cellar: :any, arm64_sequoia:     "2250d641dbaae7132f1ca809b4c54d18bd32c9b46580870c5b85aa85746b3dc1"
    sha256 cellar: :any, arm64_linux:       "8a476746535006e8191802c04ac15b9bcd3236816b6ff0453f3beb8472a6be00"
    sha256 cellar: :any, x86_64_linux:      "10c9f19b02cc972d884c3849cf7b139d193d4d5a4dd123f13ebc15261b6a2c23"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  depends_on "qtbase"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd"
  end

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
      find_package(Qt6 REQUIRED COMPONENTS SerialPort)
      add_executable(test main.cpp)
      target_link_libraries(test PRIVATE Qt6::SerialPort)
    CMAKE

    (testpath/"test.pro").write <<~QMAKE
      QT      += serialport
      TARGET   = test
      CONFIG  += console
      CONFIG  -= app_bundle
      TEMPLATE = app
      SOURCES += main.cpp
    QMAKE

    (testpath/"main.cpp").write <<~'CPP'
      #undef QT_NO_DEBUG
      #include <QSerialPortInfo>
      #include <QDebug>

      int main(void) {
        const auto serialPortInfos = QSerialPortInfo::availablePorts();
        for (const QSerialPortInfo &portInfo : serialPortInfos) {
          qDebug() << "Port:" << portInfo.portName() << "\n"
                   << "Location:" << portInfo.systemLocation() << "\n";
        }
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

    flags = shell_output("pkgconf --cflags --libs Qt6SerialPort").chomp.split
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test", *flags
    system "./test"
  end
end