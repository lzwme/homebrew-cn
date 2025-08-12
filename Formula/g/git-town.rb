class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghfast.top/https://github.com/git-town/git-town/archive/refs/tags/v21.4.2.tar.gz"
  sha256 "428b388f0adb765b5cb4cbb4e9c5d210fe83d1e82c241ac9b076b4bbd5bdde99"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "990c55abe7adf5765405d2e0e39d2dbcff53b0c89924d8e41f5a73bdbd28c7d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "990c55abe7adf5765405d2e0e39d2dbcff53b0c89924d8e41f5a73bdbd28c7d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "990c55abe7adf5765405d2e0e39d2dbcff53b0c89924d8e41f5a73bdbd28c7d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a3c5a91658cdbff9603f4bbcc91262fe3fe50ebb9e236bb5fcb343c490def32"
    sha256 cellar: :any_skip_relocation, ventura:       "4a3c5a91658cdbff9603f4bbcc91262fe3fe50ebb9e236bb5fcb343c490def32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bcd4be736fd5560b58ffa02ed10d790cc288fc75d134e8d4e6066c71eff88fc"
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