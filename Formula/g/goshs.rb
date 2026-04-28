class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de/en/index.html"
  url "https://ghfast.top/https://github.com/patrickhener/goshs/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "d135a495ea4d0f93554eff915726780738424b34c5065238ae3a4776586a66e5"
  license "MIT"
  head "https://github.com/patrickhener/goshs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19971a1035494e4b668a8e27c802d2b807d2419047f7eb8f79fa788880f9bddd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19971a1035494e4b668a8e27c802d2b807d2419047f7eb8f79fa788880f9bddd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19971a1035494e4b668a8e27c802d2b807d2419047f7eb8f79fa788880f9bddd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3877d1c1203f5bcad664b112cbb3d1d1a96de7f34c37d84d8d564a085f7e681c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28bc7100ac5057dd87fbc1ac4e6d8d008ba0ce5a574a80657596452acb6db7e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fd805b1f148a8cddc9a5523fb24fa792fb755ea4801200ea397f38b31c88a69"
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