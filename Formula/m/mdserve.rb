class Mdserve < Formula
  desc "Fast markdown preview server with live reload and theme support"
  homepage "https://github.com/jfernandez/mdserve"
  url "https://ghfast.top/https://github.com/jfernandez/mdserve/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "a35c711df811ff29333c9a3a18d47a370dda1000d7bd2283529bccd355ee3cba"
  license "MIT"
  head "https://github.com/jfernandez/mdserve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0aa98bb19f21e24a4d6e44f15ff81a34af20c8195663f110273f35b812843345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21d020412cb1507cbc836be9da1f5f66c9c6224eadf62fa1b0ccf52bd8112ce4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d4ce5730edd4252ce48e6ecdabd462e2e03e78724d5b8d8cca05c1530fff504"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a1ccf58002dfcdd62c12a51dee23fd74b932284a099f15e45a3f3db33d98a34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c96916d01d3876bf00ac6ac19803c5857f250d8488f9af32ab229e616fcf514e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfafd8fd3d500ff69c93e2c64cf0304b247c66922d62b025676c96e5683630e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdserve --version")

    (testpath/"test.md").write("# Test\n\nThis is a test markdown file.")

    port = free_port
    pid = spawn bin/"mdserve", "--port", port.to_s, "test.md"

    sleep 1

    begin
      output = shell_output("curl -s http://localhost:#{port}")
      assert_match "This is a test markdown file", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end