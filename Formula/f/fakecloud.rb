class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.4.tar.gz"
  sha256 "52f946ba3f5db91608e503f077a0cc63be60a7a3f7d70d183f51c7f1e443694c"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cc30872aaea1b433ca6ed37a104b913dadc2e227494de040eb1f1aae374a2c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be056f4a6a514d35db53f85ab71e2f05962d8598f1b349a57bce5bd331fe9d00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f8047b8a007434cbc5b67f5702e2e5bb70edcb3400fd12fdc82073af69cb62"
    sha256 cellar: :any_skip_relocation, sonoma:        "2373cf922614af1a0032d8a6a5a6dc074a130263c39bdca545cd595e23a85a07"
    sha256 cellar: :any,                 arm64_linux:   "b6e87c1aead63730a3a051cfeb026d9bc3082b94422502d8dc5dbe212dc399ce"
    sha256 cellar: :any,                 x86_64_linux:  "d7ef2f70421b47f9f2710bc10d026da281101d789cf8349732442c45de1d3836"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/fakecloud-server")
  end

  service do
    run [opt_bin/"fakecloud"]
    keep_alive true
  end

  test do
    port = free_port

    assert_match version.to_s, shell_output("#{bin}/fakecloud --version")

    pid = spawn bin/"fakecloud", "--addr", "127.0.0.1:#{port}"
    sleep 3

    output = shell_output("curl -s http://127.0.0.1:#{port}/_fakecloud/health 2>&1")
    assert_match "ok", output.downcase
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end