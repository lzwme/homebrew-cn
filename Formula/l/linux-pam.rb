class LinuxPam < Formula
  desc "Pluggable Authentication Modules for Linux"
  homepage "https:github.comlinux-pamlinux-pam"
  url "https:github.comlinux-pamlinux-pamreleasesdownloadv1.7.0Linux-PAM-1.7.0.tar.xz"
  sha256 "57dcd7a6b966ecd5bbd95e1d11173734691e16b68692fa59661cdae9b13b1697"
  license any_of: ["BSD-3-Clause", "GPL-1.0-only"]
  head "https:github.comlinux-pamlinux-pam.git", branch: "master"

  bottle do
    sha256 x86_64_linux: "a68f91985d2eef7e9010c081438d58a7d8301ce0dc1caee5f34187cdc70ba90b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libnsl"
  depends_on "libprelude"
  depends_on "libtirpc"
  depends_on "libxcrypt"
  depends_on :linux

  def install
    system "meson", "setup", "build", "--sysconfdir=#{etc}", "-Dsecuredir=#{lib}security", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Usage: #{sbin}mkhomedir_helper <username>",
                 shell_output("#{sbin}mkhomedir_helper 2>&1", 14)
  end
end