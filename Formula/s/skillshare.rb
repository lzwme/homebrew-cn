class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "f239ac1cef8cf46308b3b33bee27146f5a7a5fb343904cd5d9e86a5dead1cae4"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d586276401d22a2706d8ac06d8efd63fb21415065b68f03451e0ef26d86bd393"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d586276401d22a2706d8ac06d8efd63fb21415065b68f03451e0ef26d86bd393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d586276401d22a2706d8ac06d8efd63fb21415065b68f03451e0ef26d86bd393"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b744831248d07d5e26173d4011583ea1f3d13d0f12b2617ce7943d16909e34ab"
    sha256 cellar: :any,                 x86_64_linux:      "dcb669e9a859919e0bb4af3c851c5dac2fb5a431e482a4776c5bd629819e3f57"
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