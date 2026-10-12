class Sdrmm < Formula
  desc "Modular, client-server software-defined radio"
  homepage "https://github.com/Newspicel/sdrminusminus"
  url "https://ghfast.top/https://github.com/Newspicel/sdrminusminus/releases/download/v2.2.0/sdrmm-2.2.0-src.tar.gz"
  sha256 "38cf739c95cf078f194b829ba1c77d0c096ab69e25adc165608abb7e933de50f"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "76cfaae1b746b79fc08f26d4502dcc55bc1276b61b4e5d00c8cc683835efff3f"
    sha256 cellar: :any, arm64_tahoe:       "5c562662ddad78bafbe5300dcc7ce2ec8f6dc9b69422a2dd4c805a86f118a2f8"
    sha256 cellar: :any, arm64_sequoia:     "39a6c31b28a65da54d0363334b1bfedc64ae0dd476f8e4b5abb75952b334310a"
    sha256 cellar: :any, arm64_linux:       "8e594cabeec34453b004e4346e72f19d02f2fde255ccfea065406f4a449c2104"
    sha256 cellar: :any, x86_64_linux:      "24d6772081be3f61d0fd43c589f620e0a6b76814c1e37fa7d0a2ee376636d5a5"
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