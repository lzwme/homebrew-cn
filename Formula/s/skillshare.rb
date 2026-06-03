class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "7eee1ab479a6588991cfc1be6b8c48010ca3efedbd3fd0902f83537977446c9c"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b663212d366bd75e9525f023ae6fa41c75d78b8399dab34a58d0f976eb0a433b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b663212d366bd75e9525f023ae6fa41c75d78b8399dab34a58d0f976eb0a433b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b663212d366bd75e9525f023ae6fa41c75d78b8399dab34a58d0f976eb0a433b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1211a736e22e4a13479e2c0bcd783a820734e06a3fa6b67438042b30973ec582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9b2a2ef65141231aca2835199763b3529a983c1906883c8dd0df8f057a94526"
    sha256 cellar: :any,                 x86_64_linux:  "091ed1dbd048b22fdc730d02018779c6c6479667e0778d7023f160f59f804514"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end