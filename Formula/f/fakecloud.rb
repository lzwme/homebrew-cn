class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "8bfc6c977a773f8488911458e400d1e3bb01e0719a1c320f2286e68b7a7d4759"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a401995fb394b4cbde9a7993d1ca1e38287d40be9f89b07d63c5a0ff1ba5a8d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4470fc4f640f0ea01f07647ab1f95ac67577fd4888af6455bb5f822ef389dd12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "704d73e7e4bb361ce3d979ed35cecfa35bfad92e63edc4329484efa226f4ae9f"
    sha256 cellar: :any,                 arm64_linux:       "72892d0330ca4b22b5afe8e76b4bf5869310be18e158d8e7dbf1c2945869eccb"
    sha256 cellar: :any,                 x86_64_linux:      "55ea6312ce0a955c0c124ff435a0ec70fd2be60dd2e59075937d4e85ac174293"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "xz"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  # Update to openssl 0.10.78 and openssl-sys 0.9.114 for minimum needed to use OpenSSL 4
  patch :DATA

  # Test binds and queries a local fakecloud server
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    port = free_port
    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    begin
      sleep 3
      output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
      assert_match "ok", output.downcase
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index f63bd5443..fb0457ff9 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -9308,9 +9308,9 @@ checksum = "c08d65885ee38876c4f86fa503fb49d7b507c2b62552df7c70b2fce627e06381"
 
 [[package]]
 name = "openssl"
-version = "0.10.77"
+version = "0.10.78"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bfe4646e360ec77dff7dde40ed3d6c5fee52d156ef4a62f53973d38294dad87f"
+checksum = "f38c4372413cdaaf3cc79dd92d29d7d9f5ab09b51b10dded508fb90bb70b9222"
 dependencies = [
  "bitflags 2.11.1",
  "cfg-if",
@@ -9355,9 +9355,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.113"
+version = "0.9.114"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "ad2f2c0eba47118757e4c6d2bff2838f3e0523380021356e7875e858372ce644"
+checksum = "13ce1245cd07fcc4cfdb438f7507b0c7e4f3849a69fd84d52374c66d83741bb6"
 dependencies = [
  "cc",
  "libc",