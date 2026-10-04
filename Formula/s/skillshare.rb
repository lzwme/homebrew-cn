class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "a69a9827fa10872067fdef4b2ba7a33aaf46f8ee260b00b79ab52ebe86685b64"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5082babdef4242fe850486083e09ea9c53f1562a787c192680ed25fa6a1a488a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5082babdef4242fe850486083e09ea9c53f1562a787c192680ed25fa6a1a488a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5082babdef4242fe850486083e09ea9c53f1562a787c192680ed25fa6a1a488a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9c8366c3af2e2f28b1fb7f3d642be5498d19c798ffe6364355823cca3a6db18d"
    sha256 cellar: :any,                 x86_64_linux:      "e91475f13f3aee83be5642e8ce4438e9200854badd6ac71118ff30dab473040b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end