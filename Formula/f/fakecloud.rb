class Fakecloud < Formula
  desc "Free, open-source local AWS cloud emulator for integration testing"
  homepage "https://fakecloud.dev/"
  url "https://ghfast.top/https://github.com/faiscadev/fakecloud/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "6395ac9e2a0c17ccb0dbb9bf1b7cfa84791dac0c103eb43efb8e97cb79fe33a0"
  license "AGPL-3.0-or-later"
  head "https://github.com/faiscadev/fakecloud.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58795b000c34c275cd55f54c00e80b2c8c4bb0027068f69b36f427d16f3ffe27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4761444a9d9cad67923b9caeab548a1e514885ed2d37a34e609892c454049761"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cfcffa725acc22e46545d923c70db68538135d4f9386d4d4f6ab547c9f93274"
    sha256 cellar: :any_skip_relocation, sonoma:        "476f4c3f1e248af8ff0447f74ff562460876ea3c35c0b9c05d802dd51d90f44b"
    sha256 cellar: :any,                 arm64_linux:   "8e51d464d58ae653840a62ed7d91a9f9b820d983eeced15ff142dd8b2c45dd52"
    sha256 cellar: :any,                 x86_64_linux:  "7a123d2c3d126aae4b7a71bc48694c35b0ca2623a5f86fea63120798d63a2b98"
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