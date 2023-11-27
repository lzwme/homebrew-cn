class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghproxy.com/https://github.com/git-town/git-town/archive/refs/tags/v10.0.3.tar.gz"
  sha256 "2225a46ef9df5bb7b8e5c9d8cb7fc45c1d82eb72d05b08948be38dc19bae9ab4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15db5a0269e768d2c61c36425ed75f82305da8d7dd7d8eee9e649d0f42ad1208"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f49c0801a2123762e1147ee9ad71c0f71ebcb99764d25875a078d15980b430b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efd0a66c37e8e29db52b3431892d62c57deca8fc744bb9728dccd4a1006d5b8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b563fff7cb7a0e0cc4e485cffc0c6e8257a7f1a0b89d771c17247b506987532e"
    sha256 cellar: :any_skip_relocation, ventura:        "ef719d3deeb92ff260b9c31399b7a682316b899ec7a90f6ff3c8eaabe0b902f8"
    sha256 cellar: :any_skip_relocation, monterey:       "6f89f13a17f0e3877a3e8ffef24e34923233cca5a22538f1995dbfd91c860b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "516521bde901e6a219b5b8d94e464652293e6fd08a783af70da7d6ac4a6d8408"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v10/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v10/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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