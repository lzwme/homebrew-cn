class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.7.0.tar.gz"
  sha256 "35308388eb79032ea270bf8f96d519533547867ff40a556e2774a1c5ac843d0a"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6dc45f9628c74a6b1e17cd4394e1f7b21c852e783e358ecb2eb9683801207c5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf182d53ce0346b37bed4949a2997c8de8ce2efb26136410967cd47c368f21be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ea4fbd41116bd0ed1bc83a74937d823526903a3b99a661234f5210f263ce24d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "309d256ad0f6e90c473e565c6cbeeba4cd115cc88a3f3d2eecbf473e8adea1c9"
    sha256 cellar: :any,                 x86_64_linux:      "5cd251db7fd24a153376d17e7048db272b958bd76cb67ca6b7d66a290156f88c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end