class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.21.4.tar.gz"
  sha256 "708463a978b8cef8d1521c5ee64892caa56a0bb2bf44981cc5144b2f918c4e94"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "35be002db3cfca6ee2345f908d4a86672bd0ed3247c509fd96666b43a1217cf2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "35be002db3cfca6ee2345f908d4a86672bd0ed3247c509fd96666b43a1217cf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "35be002db3cfca6ee2345f908d4a86672bd0ed3247c509fd96666b43a1217cf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "38e0cce2630e92b720c5978a13f435215433f450b885feddf298a8bfa7207cdb"
    sha256 cellar: :any,                 x86_64_linux:      "4203a810f67c8b2a83fe7fbcc02831e3592ea21c910f868c00225c263b6b6403"
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