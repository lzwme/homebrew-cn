class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.44.5.tar.gz"
  sha256 "5899bf2d3d5527aadd13826382982a5c4aa2c311566291bd28904e86ba442401"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72deac3209f9520015d1c7ad3a2d7052aa356e52d3bc9fb511086cc6a35289af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77699d2d275a817e87c5ab02f81926b8c1ab6e70965699a48b774aa0ed0ca4d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a7c5dfd18e2c92d79639287493dba105e319883a6f952abdff789c3ba352e75"
    sha256 cellar: :any_skip_relocation, sonoma:        "c981653d9936a0939f683c873f5ca8e725cdd0f67ae8d0ec686e3b1b369a9e76"
    sha256 cellar: :any,                 arm64_linux:   "0f601eda8d8f3d5bf41d1c4e0c9b881bfcf04c3666a8df1ae4e5281bef59859b"
    sha256 cellar: :any,                 x86_64_linux:  "c7f7283d68c3709e9ec9b8052d96475451a42a0c482af2dd263ffeb1649dc800"
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