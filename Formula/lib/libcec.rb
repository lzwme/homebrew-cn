class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https:libcec.pulse-eight.com"
  url "https:github.comPulse-Eightlibcecarchiverefstagslibcec-7.1.0.tar.gz"
  sha256 "7fd60dfd25b0b116c58439bb70158c1d5fd8fd492ad2a1a3b39b826bb50b54f6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d628750a848f9fe50e393d2c188fda70aa698c19a20bbbe7dc457d5c8ddce4e"
    sha256 cellar: :any,                 arm64_sonoma:  "d43c94ebd2342cf25142ac4a489836d7f48547ea3c4da91f11cde2f9e319d401"
    sha256 cellar: :any,                 arm64_ventura: "3c2c98844f1c667bf427d61f2c8d0fa56c1dea1f9ae4aa70fa67883358826976"
    sha256 cellar: :any,                 sonoma:        "eadbe1896553e66368673fafafa958de45215947dc5991e33238e607a2f9ce57"
    sha256 cellar: :any,                 ventura:       "ef7a56b4a3c551e42823704361cc09c05c5ebd372eb3c70d9f69700a7a1cdf2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3624133784229fd025d4b4d067ec8efaaac2724b968fe09b0ab8498cb4f1ebda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c12de1b683cf73a0a6a9034566c9be66e62bc51bb84e399fe913e6f6a84dff"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  resource "p8-platform" do
    url "https:github.comPulse-Eightplatformarchiverefstagsp8-platform-2.1.0.1.tar.gz"
    sha256 "064f8d2c358895c7e0bea9ae956f8d46f3f057772cb97f2743a11d478a0f68a0"

    livecheck do
      url "https:github.comPulse-Eightplatform.git"
      regex(^p8-platform[._-]v?(\d+(?:\.\d+)+)$i)
    end
  end

  def install
    ENV.cxx11

    # The CMake scripts don't work well with some common LIBDIR values:
    # - `CMAKE_INSTALL_LIBDIR=lib` is interpreted as path relative to build dir
    # - `CMAKE_INSTALL_LIBDIR=#{lib}` breaks pkg-config and cmake config files
    # - Setting no value uses UseMultiArch.cmake to set platform-specific paths
    # To avoid these issues, we can specify the type of input as STRING
    cmake_args = std_cmake_args.map do |s|
      s.gsub "-DCMAKE_INSTALL_LIBDIR=", "-DCMAKE_INSTALL_LIBDIR:STRING="
    end

    resource("p8-platform").stage do
      # upstream commit, https:github.comPulse-Eightplatformcommitd7faed1c696b1a6a67f114a63a0f4c085f0f9195
      ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"
      odie "remove CMAKE_POLICY_VERSION_MINIMUM env" if resource("p8-platform").version > "2.1.0.1"

      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "libCEC version: #{version}", shell_output("#{bin}cec-client --info")
  end
end