class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.7.2.tar.xz"
  sha256 "5f6a227390fcd4c2d0a8028a652b55a9d863ec7be01298fe038df1d273fb9a0f"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  revision 1
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://www.knot-resolver.cz/download/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t[^>]*?>[^<]*?stable/i)
  end

  bottle do
    sha256 arm64_sequoia:  "04189bca50db5055b0ded9abc57313d07ffe3ceafa7f5d397da431d83a6352cc"
    sha256 arm64_sonoma:   "15dec163e7bf0696107328c5aa631008bc1aa80da6b3dc3f61084d95eee9fb8a"
    sha256 arm64_ventura:  "428e8c668dd8e505cb466b61768bf68a00bec6df74f5127df4ff9ffda996fbb9"
    sha256 arm64_monterey: "1b1abdbbd510f69ad88f4d017f49aee7f6390aba39e7db5cff0c6e261b305f6b"
    sha256 sonoma:         "ea8eaede7c0958475f25e78427ea7c6615d25a2ad23d2f3f5464771a23b929e7"
    sha256 ventura:        "c4599e3b84e79e3ec10205ee4301441e98d01bcc87fc4a81c5ec23bfacf93e08"
    sha256 monterey:       "d5742ec68d6657fc91f7037b79c7c36d52715f5cfef9f368cdbccb3376cbc61c"
    sha256 x86_64_linux:   "3153b8157b8b0da93222eb84d0565bd8c651dc95e29a8174ec438acde50666c1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit"

  on_linux do
    depends_on "libcap-ng"
    depends_on "systemd"
  end

  def install
    args = ["--default-library=static"]
    args << "-Dsystemd_files=enabled" if OS.linux?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    (var/"knot-resolver").mkpath
  end

  service do
    run [opt_sbin/"kresd", "-c", etc/"knot-resolver/kresd.conf", "-n"]
    require_root true
    working_dir var/"knot-resolver"
    input_path "/dev/null"
    log_path "/dev/null"
    error_log_path var/"log/knot-resolver.log"
  end

  test do
    assert_path_exists var/"knot-resolver"
    system sbin/"kresd", "--version"
  end
end