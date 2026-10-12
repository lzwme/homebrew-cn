class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.25.5.tar.gz"
  sha256 "262b9e0033c5da79106dd39858a32611f9d6bbf2aa57d6846514502c3b40ad26"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82e948d220cd3d40c3cf02ea834a7ff9dbafc0058b2794295049313cc436624e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82e948d220cd3d40c3cf02ea834a7ff9dbafc0058b2794295049313cc436624e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82e948d220cd3d40c3cf02ea834a7ff9dbafc0058b2794295049313cc436624e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3d2b3956d895262fe5ea40c2aa4f7ec26a4d35ff5ba34dcaa8a9b4a11b15403f"
    sha256 cellar: :any,                 x86_64_linux:      "4837b52ab62ff34822ccd98a112a5614ff289bc88e448cd5a94e3a00f0d5ab2e"
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