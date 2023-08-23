class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.7.0.tar.xz"
  sha256 "383ef6db1cccabd2dd788ea9385f05e98a2bafdfeb7f0eda57ff9d572f4fad71"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0e1274ddc57db35e579b734f77df4d7b7904d54b3e5021f32c0c643eb08190c5"
    sha256 arm64_monterey: "dcab2be0fad605f28ccbec9f5d87933d9199e47f8447d9a7562a1836b78a0501"
    sha256 arm64_big_sur:  "cec36062181ed6d7f7cd0b5c660af37f74cf2fa55384443ccc5ae4562155b803"
    sha256 ventura:        "1f415a229e9ac1af89603fc2df28c6f5259adc13525e0f3e6f3cab60ce9e2f3b"
    sha256 monterey:       "e4e3991148d3ba950d70f2d73f28e374288bed9ff3ccf3602906f99540f5739d"
    sha256 big_sur:        "17fde0ae5f3b80df699654c303466a2c23ca36651cc4eb7e60903d8c93d44293"
    sha256 x86_64_linux:   "af3faf4977aff5279ecb857a4c17eb7985dc3019746a33f372489d858f8238d7"
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
    args = std_meson_args + ["--default-library=static"]
    args << "-Dsystemd_files=enabled" if OS.linux?

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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