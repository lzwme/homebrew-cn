class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://ghfast.top/https://github.com/patrickhener/goshs/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "47c78f57e20afc2a11fff8c0ea352470176fc84ce70f0ef23a19302c81e9b0be"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bfe59749a099252308870e08b29ef25f4b3335be8b11f03664a2e2888b0b144"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bfe59749a099252308870e08b29ef25f4b3335be8b11f03664a2e2888b0b144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bfe59749a099252308870e08b29ef25f4b3335be8b11f03664a2e2888b0b144"
    sha256 cellar: :any_skip_relocation, sonoma:        "420a7ccdb658225a4471d4ec09fbf0a6be287cf27ce65677290da5d06940627c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24392ff28cfd02f2b09e637a8234dfaeb163ed23f78b330d54ff9f485a49179a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70acb02cdeb6fc64bb6ce74eaa5e2ec4f6d345b0163986f92f2b4a8f9a7014b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goshs -v")

    (testpath/"test.txt").write "Hello, Goshs!"

    port = free_port
    pid = spawn bin/"goshs", "-p", port.to_s, "-d", testpath, "-si"
    output = shell_output("curl --retry 5 --retry-connrefused -s http://localhost:#{port}/test.txt")
    assert_match "Hello, Goshs!", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end