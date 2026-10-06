class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "8cbac1f7dc459d0f691d11dab82863953aa7b270d77c50a2ff873e292a37fda1"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4d6b67f9c7ecfaba10eb2850658d360092591271949376b1551f2f59795f4e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f344fb0efedf9defabc58b17a72cf47db767525af79cde646e63b9201b1904db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcfc581582b90afd8ac90a0c3a97f23c17830ba34d76f9fe84a39879afb46a57"
    sha256 cellar: :any,                 arm64_linux:       "297a5c3f8886104db87523cdea057a9017a038f529f85af285c9594103620103"
    sha256 cellar: :any,                 x86_64_linux:      "bd528601fb5a4ec855222a894eeb80dde4998e79f8bfbb6bbc278304002985ff"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

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