class Gammu < Formula
  desc "Command-line utility to control a phone"
  homepage "https://wammu.eu/gammu/"
  url "https://ghfast.top/https://github.com/gammu/gammu/releases/download/1.43.3/Gammu-1.43.3.tar.gz"
  sha256 "a340b8347f5b30c84aa2a48fc497560fdc0d613618baa14b1bad94b3f316c7ff"
  license "GPL-2.0-or-later"
  head "https://github.com/gammu/gammu.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "0a35b12b38e119d55e6f4e0f0afb8fcd7ca651fa483257b6cf629828666e9af1"
    sha256 arm64_sequoia: "b0f1d27ec6d3eb2c3bcc76e76e8225aa0c253de28835dba99c2b238924324af2"
    sha256 arm64_sonoma:  "9bc4d6542abd510fe93fc524863ba40d1bc09f57c71a535904b2cc3f64fafebf"
    sha256 sonoma:        "505eab052122d9aacd6bd301b88270dac3ddc1a017bc6d13666bad365ff79dd9"
    sha256 arm64_linux:   "2a65bec55c77c18b5db0774b9ea1bee428f8e3dd221a446a6c3b3eb688d6611e"
    sha256 x86_64_linux:  "e3eb0fb3848ae6b8f8d4fc01f719ef0a003788650f65e9ede6bada0eebc5c88c"
  end

  depends_on "cmake" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -DBASH_COMPLETION_COMPLETIONSDIR=#{bash_completion}
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_Postgres=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"gammu", "--help"
  end
end