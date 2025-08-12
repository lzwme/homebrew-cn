class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://ghfast.top/https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.54.2.tar.gz"
  sha256 "27237c1c30f866d5adf1682b85db549d9874f89491093230ee0c5ea361617c7c"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a305dd41ef8ce8015540e48c3bc592383668f1e4c62393624975ff2bd6fae2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a305dd41ef8ce8015540e48c3bc592383668f1e4c62393624975ff2bd6fae2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a305dd41ef8ce8015540e48c3bc592383668f1e4c62393624975ff2bd6fae2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ed808c57884c5915d0f5ce536273fd8273b1da4f43e1b8f0f743494305f4996"
    sha256 cellar: :any_skip_relocation, ventura:       "6ed808c57884c5915d0f5ce536273fd8273b1da4f43e1b8f0f743494305f4996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74a24de5418526cf06b5559038133170a78428e853b654ba379de69772d3a84"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end