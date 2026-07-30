class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.9.tar.gz"
  sha256 "4815d1e2620b429e8047a0bba4a0f48d891d12fc0bb0cf48974e07d846b2da97"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dbc84b74d5c2f83efb6d79ffc3a6e6994cbe209fc35887db14212ae4889385d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7229eadb020b0dd61f6102419f6693d1a83379d1fa7427f8095a7f2f2f9da730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92faef715a573d4fe6f5c2cd7f01d5885b2e53cd8c10eaa02b1c600765c3219f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a94c0b7c2d4c82f3d6a2ac18c38813ee68d59cd88e0aaf35d4a2b2fdb2d040f"
    sha256 cellar: :any,                 arm64_linux:   "a6ec4b780fee3ccea6e574168426aa6403e6ee4ff315a2854c59f88c1aea7fe4"
    sha256 cellar: :any,                 x86_64_linux:  "7d4ae72cbadb1782b9e38a30a2888d8b25e022e26bca5f6bc6de04700e1a8d78"
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