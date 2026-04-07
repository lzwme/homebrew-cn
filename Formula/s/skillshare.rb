class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.18.8.tar.gz"
  sha256 "b7907035662e80cd4884cb8f752888d87c4e49f7bd5f8a2e39d70c971d5aed4c"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3517b15dcb40fd0c42bfdce40be35c27cd3e7d7ea468863006ff1b385a57ed4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3517b15dcb40fd0c42bfdce40be35c27cd3e7d7ea468863006ff1b385a57ed4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3517b15dcb40fd0c42bfdce40be35c27cd3e7d7ea468863006ff1b385a57ed4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "42409703484a83ab64e3bee78de1ecaf106464b30bb2e40abb9f029524ec4eb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f56a21c35aa5ae71dc0654c9fb29409c6a4f3e6bef2158e6456c08bb01239db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94cfa0d12db692cb3083c06eeff57dda49299d74ce514c6c4aaed44f627e53ec"
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