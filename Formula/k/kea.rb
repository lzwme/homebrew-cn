class Kea < Formula
  desc "DHCP server"
  homepage "https://www.isc.org/kea/"
  # NOTE: the livecheck block is a best guess at excluding development versions.
  #       Check https://www.isc.org/download/#Kea to make sure we're using a stable version.
  url "https://downloads.isc.org/isc/kea/3.2.0/kea-3.2.0.tar.xz"
  sha256 "14bf695d37b65b9b1bf550fea5d0adaf9806c50e5419ef2a176a4b8e9aade3df"
  license "MPL-2.0"
  head "https://gitlab.isc.org/isc-projects/kea.git", branch: "master"

  livecheck do
    url "https://downloads.isc.org/isc/kea/"
    regex(%r{href=["']?v?(\d+\.\d*[02468](?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 arm64_tahoe:   "b1db4f18e45523a6a76c70dfa149eb654128268024083569d66297065b8cf452"
    sha256 arm64_sequoia: "907c57a685d9ccc33a3956b0ac9f766feffdc2171336e73ca6e63db3e81597d4"
    sha256 arm64_sonoma:  "dbf1d8bd8e09f619da04baed80f6d0617502e92d9d8b32e3e564ee7aa745ea0d"
    sha256 sonoma:        "4c291c977366043b78c091a98c0128937f1f19d0535fc31a33c60bbac65e008a"
    sha256 arm64_linux:   "f852801894440b238f479f42244da71469a3306df83626efd8c7a7db0b45866e"
    sha256 x86_64_linux:  "0078f9fa3b61b569fb260c7ecbcdc870c4c3efd5924b7d5a0fe38350d6bb2b01"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "boost"
  depends_on "log4cplus"
  depends_on "openssl@3"

  def install
    # the build system looks for `sudo` to run some commands, but we don't want to use it
    inreplace "meson.build",
              "SUDO = find_program('sudo', required: false)",
              "SUDO = find_program('', required: false)"

    # Some scripts expect var and etc to be relative paths
    args = %W[
      -Dcpp_std=c++20
      -Dlocalstatedir=#{var.relative_path_from(prefix)}
      -Dsysconfdir=#{etc.relative_path_from(prefix)}
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system sbin/"keactrl", "status"
  end
end