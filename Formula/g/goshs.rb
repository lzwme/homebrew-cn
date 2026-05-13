class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://ghfast.top/https://github.com/patrickhener/goshs/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "ebc1392ede99303c14095df6d9069daee7dd43c03b121ca752905a2175909601"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aea888fb42d7231d4925614b25340612657b6c73a25375559278744f7f1efe24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aea888fb42d7231d4925614b25340612657b6c73a25375559278744f7f1efe24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aea888fb42d7231d4925614b25340612657b6c73a25375559278744f7f1efe24"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a875aca72ed47c71b41837815dd62ad5cec970868329027f43b0e69b9044bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff50b02496951335d0473d1e394d30be1a2eaed95211bd4e1cb338e01c03db34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e460d42df0c04244755a93bdd37962b5e0d5aaf5dc9f00e48e9ac4de5d20797c"
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