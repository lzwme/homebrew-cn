class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "31ec1c55d9898a27a066de684caa44becbced2fe8c12c0b0e831b2ff9d62f6d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ed4890626497c6f1452570508e500ac494e73bfc74e7a3581ab75bb0353f54e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed4890626497c6f1452570508e500ac494e73bfc74e7a3581ab75bb0353f54e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed4890626497c6f1452570508e500ac494e73bfc74e7a3581ab75bb0353f54e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a79bd72b5ddef28016239d7dac74704de5d472dbcdb44fba4ae2544a136ae97b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea3a0849a2a8bb9ff642b2f5bc1b103cf354423a51ff86a7ecaaf1c3a7d1f8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db44496d07ad385395e6608258a259ecb6f78bfd25c8b7978eb0a9bb56ffbca1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end