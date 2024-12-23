class Minisign < Formula
  desc "Sign files & verify signatures. Works with signify in OpenBSD"
  homepage "https:jedisct1.github.iominisign"
  url "https:github.comjedisct1minisignarchiverefstags0.11.tar.gz"
  sha256 "74c2c78a1cd51a43a6c98f46a4eabefbc8668074ca9aa14115544276b663fc55"
  license "ISC"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f0ac0fea74f76a2386da2de3c7faf6f757686ae623dc88f9eb1f4e4eecbe58ec"
    sha256 cellar: :any,                 arm64_sonoma:   "15bb5196196433571ebaf41afe8005ea47912d16dafe3c2d4fa4d2e0e18fc9a5"
    sha256 cellar: :any,                 arm64_ventura:  "a81fea50d53645c045ab117414f4aa99567bc38fe735f48766956d82e29eec5d"
    sha256 cellar: :any,                 arm64_monterey: "45006c92f229303c788dd4b73bc5c3872c88eddb127fd75b508f9e8c356d2ebe"
    sha256 cellar: :any,                 sonoma:         "c9757b400301bec4203e95955c7ce34be0e6f54039b77bd470b97a05feba7dd4"
    sha256 cellar: :any,                 ventura:        "9daec2dcc65faacb0d701749a16d354c72a2426fe951b0d9b275281e17a881ef"
    sha256 cellar: :any,                 monterey:       "dc38390b76728747a95b3675094ef600b564467ce2c390229e8dd1cbeb7f10fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a0a5c0e17f95961134b996c04fc60d978a53abd2835f88a326aebfffcb66cc0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libsodium"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    require "expect"
    require "pty"

    (testpath"homebrew.txt").write "Hello World!"
    timeout = 5

    PTY.spawn(bin"minisign", "-G") do |r, w, pid|
      refute_nil r.expect("Password: ", timeout), "Expected password input"
      w.write "Homebrew\n"
      refute_nil r.expect("Password (one more time): ", timeout), "Expected password confirmation input"
      w.write "Homebrew\n"
      r.read
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_path_exists testpath"minisign.pub"
    assert_path_exists testpath".minisignminisign.key"

    PTY.spawn(bin"minisign", "-Sm", "homebrew.txt") do |r, w, pid|
      refute_nil r.expect("Password: ", timeout), "Expected password input"
      w.write "Homebrew\n"
      r.read
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_path_exists testpath"homebrew.txt.minisig"
  end
end