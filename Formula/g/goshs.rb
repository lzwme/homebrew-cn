class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://ghfast.top/https://github.com/patrickhener/goshs/archive/refs/tags/v2.0.9.tar.gz"
  sha256 "360cc2b9ca78db2d69ba5b45d09a6279bdf575df1babe306f21c3e619a591c97"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cf25d1e9e300d7aed814aa65ddb1862eadc3f35b0d4dc62272da84c1d56dd73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cf25d1e9e300d7aed814aa65ddb1862eadc3f35b0d4dc62272da84c1d56dd73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cf25d1e9e300d7aed814aa65ddb1862eadc3f35b0d4dc62272da84c1d56dd73"
    sha256 cellar: :any_skip_relocation, sonoma:        "8913abad217c63c610781dda464e233227ccf9298502a29e3d1b15fee2a1d4ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "625534b4f2cf8473542885c9c96a64cf3808f30ec6e27c957832b616ba143010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c887ebdeb173261aa093cfc1b8764596ef8ee32de2280a912af3cac55b2e75ae"
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