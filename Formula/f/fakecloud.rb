class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "20d3a5bfeb606dbbd3442773c26df3a2f052c5440475f847d4b8dd01d4e98e3c"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d662035582570540063d06ee2683ad1702fa2e2892fbb3828e059fe5b8b54be5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f302bcc43b23d249697c4bc7f388c8c808c678f522aaa2f2b9e9cda226a379e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5eae44b79c6ec814a2b3d871488299838af46aaf4c6165f1725402030d5d399"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a5efbeeda66be4709fcf62b561e299952c43c7017abcdc004c017dd9077b0a9"
    sha256 cellar: :any,                 arm64_linux:   "d2e3f22ed6d7e12b38b84958aab4d657be21f40fe4240407ffa2938d8c3093de"
    sha256 cellar: :any,                 x86_64_linux:  "52e53f19a0834224df3cb3210a593521ef257e973959cf2fc5460c6a18012e42"
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