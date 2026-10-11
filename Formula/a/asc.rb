class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.14.1.tar.gz"
  sha256 "7389815ef5d3e131e4338c1e6a05a0bf0fa235e8624be05fae0cbcb9f2ccfc71"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60688aa2c270020e1eec14bca7a4160a582781a410176160be2a4ed14f2798ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85dea296abb108c9ae29823115f53ac8b088ac9d6b6d0ed08d3f97b593de740e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "485e0ad59946cad621ba7797c53a67974bb69fe93941c63bb590fc4331e5ab8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb7664e245736983fadfcf6a006de86d0feae260675186c72e620d703946b3c0"
    sha256 cellar: :any,                 x86_64_linux:      "e8efa4a1ccb0d0a796799210db95d968eeb451e6ac9d2f03b395ef26b6033b90"
  end

  depends_on "go" => :build

  conflicts_with "asccli", because: "both install `asc` binaries"

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