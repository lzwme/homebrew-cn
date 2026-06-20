class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "7ba2789a76c781ea565d65b35ca600fd0f1fe3a305c93977dee0a3ac7217c223"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cafabc89e3e10ff1d06908440a169636d1aa5f633e396a26854768cfcbe4278"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf836b5e4cdd599efff1befbf68a43a03998dd808bd498b9f8e99d93c00d2530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b07545b84d8a2cb2810f12d84cf2d9a6b7c893320f6d922baa777107b882e331"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4fe806740a41017bdd82a54ab810f5682aebf1a9b4010d8be67dac4fc40cea0"
    sha256 cellar: :any,                 arm64_linux:   "b8f2c7aa514c49087eac467b6ab5271f33f1cd92b9377ae6d66a1907b30874d7"
    sha256 cellar: :any,                 x86_64_linux:  "95098bce58718f652cbe84e2f74a52a8781c2c4fada7b44512fdcf8cd5d903d6"
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