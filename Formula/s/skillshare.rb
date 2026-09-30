class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "1699160c4e52f21acdb3ea001fd7f527850fb024b5c88e89ef8b0dc8c226fce0"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "301707eb84ea356c5d94de2875b96518fc834667d1ab98ef786adae32cfab44a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "301707eb84ea356c5d94de2875b96518fc834667d1ab98ef786adae32cfab44a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "301707eb84ea356c5d94de2875b96518fc834667d1ab98ef786adae32cfab44a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ca4e0d605719f357bb1096f6bd3ca6506c954ceb16d7a069bd86751340a6573"
    sha256 cellar: :any,                 x86_64_linux:      "b40cbe8f5fb663a7d4362f73419b3da978bf91c4a56346be12a72f6f81416bff"
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