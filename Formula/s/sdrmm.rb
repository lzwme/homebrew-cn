class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://ghfast.top/https://github.com/Newspicel/sdrminusminus/releases/download/v2.4.0/sdrmm-2.4.0-src.tar.gz"
  sha256 "7ab8e7bee285df6b4c611f19d49e2623bc69267a740643a05cf7172fafcd61e4"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d5cf02d64804b496f12a1684ded515a75e2526c54112c9d08c323d2db813f4fa"
    sha256 cellar: :any, arm64_tahoe:       "4f66b477745da8d08abde870fd423ce595517fc7818b46b0d6aab86e622f9efb"
    sha256 cellar: :any, arm64_sequoia:     "1649e7a3c96068b2d649166e39a701a8b5b32f062a20d8a041b2d5d1ef6809a9"
    sha256 cellar: :any, arm64_linux:       "7281b11dd4a1f9df3123419fa195aef8b88a6de3f8974559b38fbfee75863812"
    sha256 cellar: :any, x86_64_linux:      "e82f8d29dd137a6ac600191c2114eef8ea6188df7c1f048fe97e0825f657a68f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build
  uses_from_macos "sqlite", since: :tahoe # requires sqlite3_set_clientdata

  # starts a server to test with
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    system "cargo", "install", *std_cargo_args(path: "apps/sdrmm")
  end

  service do
    run [opt_bin/"sdrmm"]
    keep_alive true
    log_path var/"log/sdrmm.log"
    error_log_path var/"log/sdrmm.log"
  end

  test do
    assert_match(/\[ok\s*\] Device backends/, shell_output("#{bin}/sdrmm --doctor"))

    port = free_port
    pid = spawn bin/"sdrmm", "--bind", "127.0.0.1:#{port}"
    begin
      url = "http://127.0.0.1:#{port}"
      status = shell_output("curl -fsS --retry 30 --retry-delay 1 --retry-all-errors #{url}/api/status")
      assert_equal version.to_s, JSON.parse(status)["version"]
      assert_match '<div id="root"', shell_output("curl -fsS #{url}/")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end