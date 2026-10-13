class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://ghfast.top/https://github.com/Newspicel/sdrminusminus/releases/download/v2.2.1/sdrmm-2.2.1-src.tar.gz"
  sha256 "e1bc52a6cdd882667cda78532f73ac29228cbb87e672fab7454e45b7efbe18b7"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "59e247d1a7e77a2892de1ce2796c61d7b7c1e6b04669ba8775518ad38285bfab"
    sha256 cellar: :any, arm64_tahoe:       "30e111d7cf3bbaef6f513ddd078a4ef7b9747bf4c2cd3d6e5cbda965f58f641a"
    sha256 cellar: :any, arm64_sequoia:     "19002a1b802b6cf527856a6d7deeca143b0d49f5ac408b993061a933b7c139a2"
    sha256 cellar: :any, arm64_linux:       "cdc3b95ed31b75ac6f29d8bad89b4872cf95029bbb2e48b9c7fcd2bd97df7c74"
    sha256 cellar: :any, x86_64_linux:      "8a89c4d966a84c12e78b57557a41d77b76c2c0a85fe43674b0faf396f7a33322"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build
  uses_from_macos "sqlite"

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