class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/1.4.0.tar.gz"
  sha256 "7a4a7dab247e711c7223cbb01116ea9582d3b597bbe8698ff1a440e723e9e507"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a6021c26b8a7ee3dc1456407fe395a6a21a64db289355742df74db7498dc82b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7d819b911177fc811bb66d6c8e1dacbf4b3e646393c95f8d2b8b0c9de7a2bf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "692c2228532856221f14da79c2e5ad417832d95643141c63ccf9fe6c1a837397"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dcf0245ab1451ae753e2ddf60012e405470a86160b68a99a56d0aec5ec95326"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2906f7c5085c40c6f88431d630407f1ad0cdf1fb4467977527e9e2161182e20b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16764420ebe329cf291964352f2ab93406228d608cfa89c0e01efdcbcf5fdbea"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
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