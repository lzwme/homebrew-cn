class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.24.5.tar.gz"
  sha256 "1a74c69a80effdb5232974057dcb39a0fa210f75401ced66734986b2e14b6bbb"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "87810fa9e560880b54d71becf061b05e93c2a1d50cbb5f6bda0d1fa01804979a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "87810fa9e560880b54d71becf061b05e93c2a1d50cbb5f6bda0d1fa01804979a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87810fa9e560880b54d71becf061b05e93c2a1d50cbb5f6bda0d1fa01804979a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "227e1e545be1fc452a7610abab484aa0930f3d318068a63d35a97534e73c60c9"
    sha256 cellar: :any,                 x86_64_linux:      "07a7b938cb1576a8a9b4233301fe57d719a237fa3abca37f1a90cb95da9d530e"
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