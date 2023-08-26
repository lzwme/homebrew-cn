class BazelRemote < Formula
  desc "Remote cache for Bazel"
  homepage "https://github.com/buchgr/bazel-remote/"
  url "https://ghproxy.com/https://github.com/buchgr/bazel-remote/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "c0c037589dba49329b5ad4947dce0af82abf4d53298ae32fb88cbafdbe5bf0dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dcf61e7cea7f0f04a333458798e37b5ba9afa93e06282ddfafe4925a46e6dca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaa0577a258d1fc18f2d3741fb9c7f5f3f860502d332e0936d3c7cafdc324bfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3a12be536fcbe1732d7ac81c0d129173807e23c66d50f65c5f0514733206195"
    sha256 cellar: :any_skip_relocation, ventura:        "0cd9972c4a5f15814060dc76fa25c3eec25c1f34f332dedc8d5a5117c056ff31"
    sha256 cellar: :any_skip_relocation, monterey:       "8bf61b11e6d1123db56bbef8878dac31a6e188d051d06d904ba65d0fa0121a74"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec7428bd881d456f38e731bdccd1d3a97c8871529e762bca0d67fad8cdecf16a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f5ba898e0fd0687d9bf7cbfa6ea68fa817c4d4c7501408b805ffd3fd1b5380"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.gitCommit=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    ENV["BAZEL_REMOTE_DIR"] = "test"
    ENV["BAZEL_REMOTE_MAX_SIZE"] = "10"

    begin
      pid = fork { exec "#{bin}/bazel-remote" }
      sleep 2
      assert_predicate testpath/"test", :exist?, "Failed to create test directory"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end