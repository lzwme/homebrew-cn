class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghfast.top/https://github.com/git-town/git-town/archive/refs/tags/v22.1.0.tar.gz"
  sha256 "b44b8f1f5a8c794e8796e308f593c580b414d739c3f5ab0f957d7047ced2604c"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cda4be538a72615d04a5dbb6618a0a68bf42af16690ba236d684ffe25c87b01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cda4be538a72615d04a5dbb6618a0a68bf42af16690ba236d684ffe25c87b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cda4be538a72615d04a5dbb6618a0a68bf42af16690ba236d684ffe25c87b01"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e1dae41c0b7bf5e07fa8f05ac23ec58d34363fbad95a847d2bee4ffa055d27a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "723a6448baf89a543ff1c3e88de5e2e4fadcc2c601091eb470cbe0e4cdb0d1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c896d6b6da6ad9f4d2f8a38af9c48bfafd81e5b4eed5a1a934e2312e5f4ae3e1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end