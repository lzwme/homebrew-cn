class Orbuculum < Formula
  desc "Arm Cortex-M SWOSWV Demux and Postprocess"
  homepage "https:github.comorbcodeorbuculum"
  url "https:github.comorbcodeorbuculumarchiverefstagsV2.1.0.tar.gz"
  sha256 "ccdd86130094001a0ab61e5501a6636e12c82b0b44690795a2911c65c5618c46"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "556cd8cbd595a45ac1c8990a2614b48b894374e96f2795bfea176297e8151d18"
    sha256 cellar: :any, arm64_ventura:  "8c6a7c6c15b2d618e7df9fe26d6962d6e09251fb7f421c69e5ea97de8aa6e9db"
    sha256 cellar: :any, arm64_monterey: "f947c45c58dc788c8b01e4bd6f4fa9dc6e717d7df77c08c181f0ce57dcc9f607"
    sha256 cellar: :any, sonoma:         "eb447bef31cb0ce5f7b26e2f2bbc35e2d6019caf5d5bb9b8c8d669e11e599ea7"
    sha256 cellar: :any, ventura:        "43d6988953f1798a89e73143f91e68d0738ee21028271c74d0200b67fdd7854f"
    sha256 cellar: :any, monterey:       "706ebe4db79b819f884e13db2d54b32b408f4ac971ea754b5f61c7987c4f910a"
    sha256               x86_64_linux:   "ee7af224831a8aa48cdf5980457d49e4ec80dd4664810d98442bc2039a02804e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "libusb"
  depends_on "sdl2"
  depends_on "zeromq"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "libelf"
  end
  on_linux do
    depends_on "elfutils"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build", "--tags", "devel,runtime"
  end

  # The tools do not report their version correctly when installed from a
  # GitHub release rather than from Git directly for versions <= 2.1.0.
  # This has now been rectified, and the versions can be tested for future
  # releases.
  test do
    assert_match "orbuculum version undefined", shell_output("#{bin}orbuculum --version 2>&1", 255)
    assert_match "orbcat version undefined", shell_output("#{bin}orbcat --version 2>&1", 255)
    assert_match "orbdump version undefined", shell_output("#{bin}orbdump --version 2>&1", 255)
    assert_match "orbfifo version undefined", shell_output("#{bin}orbfifo --version 2>&1", 255)
    assert_match "orblcd version undefined", shell_output("#{bin}orblcd --version 2>&1", 255)
    assert_match "Elf File not specified", shell_output("#{bin}orbmortem 2>&1")
    assert_match "This utility is in development. Use at your own risk!!\nElf File not specified",
                 shell_output("#{bin}orbprofile 2>&1", 254).sub("\r", "")
    assert_match "Elf File not specified", shell_output("#{bin}orbstat 2>&1", 254)
    assert_match "Elf File not specified", shell_output("#{bin}orbtop 2>&1", 247)
    assert_match "No devices found", shell_output("#{bin}orbtrace 2>&1")
    assert_match "orbcat version undefined", shell_output("#{bin}orbzmq --version 2>&1", 255)
  end
end