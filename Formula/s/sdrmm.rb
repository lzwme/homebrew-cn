class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://ghfast.top/https://github.com/Newspicel/sdrminusminus/releases/download/v2.1.0/sdrmm-2.1.0-src.tar.gz"
  sha256 "1b46991884c8c137007471401477d893740a07d39d63a6d488f3c330588360ea"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a1471f8a7f63c317b147f9cd0a7ba7c596b64a6ddac20653a7e560c7a01be217"
    sha256 cellar: :any, arm64_tahoe:       "f2dad71842454ec3a06c9929652ed10402d564564331373459f721e3f80271ff"
    sha256 cellar: :any, arm64_sequoia:     "41dfa691d18266ca8244064a30f5195d70a3c7404bffa179f3781962abd0de6f"
    sha256 cellar: :any, arm64_linux:       "fca523f42c5c01666b1f26d1e7d3bd0c65d848e50ba9c6d66785896233c64fb7"
    sha256 cellar: :any, x86_64_linux:      "3e60b25a3b9a1edcede37a9d9b8b6b7144a3d4f167b4cd0a637eddf42868f682"
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