class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.21.14.tar.gz"
  sha256 "948f220d3208dbb072acc3a03362a9f57a7003a78985d31d8e7037d2eaa0ce44"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86ff02ce295c9a9a5e68641502a2f181c80e75607a664aa4574da45cad0412ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86ff02ce295c9a9a5e68641502a2f181c80e75607a664aa4574da45cad0412ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86ff02ce295c9a9a5e68641502a2f181c80e75607a664aa4574da45cad0412ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81a53f70e708c758d4304f615939074ae33b39a9b0002e6d149969160d431da2"
    sha256 cellar: :any,                 x86_64_linux:      "813a1681d33ec3103625b52a4107ba743cb65cbdf675e0fe82a97fb06d758890"
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