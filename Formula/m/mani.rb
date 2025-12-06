class Mani < Formula
  desc "CLI tool to help you manage repositories"
  homepage "https://manicli.com"
  url "https://ghfast.top/https://github.com/alajmo/mani/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "fdcf1b91ee8fb9403c9d70ae6703af05961df7b4daf906dee667ae31a6ee6925"
  license "MIT"
  head "https://github.com/alajmo/mani.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd2cb9c25d3bafa58d0648d7aed5c8a7ca2524324dc91d57583b2d3e9aa0186f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd2cb9c25d3bafa58d0648d7aed5c8a7ca2524324dc91d57583b2d3e9aa0186f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd2cb9c25d3bafa58d0648d7aed5c8a7ca2524324dc91d57583b2d3e9aa0186f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac2af8fa0a1fb06aa13f372d3e71e1d097449d7f24f1ee43fbd0cbd39b87f7b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "239ffb5611d45e97fa3d03e414d94641d20c69de4e83676a8493daf9ed1576d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5f7aac17123094d0c253cce1e92f3a2ef55183fd4735e9176501ed04c6fa897"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alajmo/mani/cmd.version=#{version}
      -X github.com/alajmo/mani/core/tui.version=#{version}
      -X github.com/alajmo/mani/cmd.commit=#{tap.user}
      -X github.com/alajmo/mani/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "netgo")
    generate_completions_from_executable(bin/"mani", "completion")
    system bin/"mani", "gen"
    man1.install "mani.1"
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/mani --version")

    (testpath/"mani.yaml").write <<~YAML
      projects:
        mani:
          url: https://github.com/alajmo/mani.git
          desc: CLI tool to help you manage repositories
          tags: [cli, git]

      tasks:
        git-status:
          desc: Show working tree status
          cmd: git status
    YAML

    system bin/"mani", "sync"
    assert_match "On branch main", shell_output("#{bin}/mani run git-status --tags cli")
  end
end