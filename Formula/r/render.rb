class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "9158d6ec06b2fb19d79eefdb1e1fa141beac22b408733cc46442760e7c420d8c"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "253744517f3b4d5a125957439637138641f90b9a20786ba2e36b0fcd8fef7c6f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "253744517f3b4d5a125957439637138641f90b9a20786ba2e36b0fcd8fef7c6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "253744517f3b4d5a125957439637138641f90b9a20786ba2e36b0fcd8fef7c6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d7fd91dd215bcf8367f56abd52080e765aedda18c68a08812f5db095d98d4c60"
    sha256 cellar: :any,                 x86_64_linux:      "420d762ffebbb84999f42b4b9e00437f730324a497b99310ec5f475af7bf7b4e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/render-oss/cli/pkg/cfg.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/render --version")

    output = shell_output("#{bin}/render services -o json 2>&1", 1)
    assert_match "Error: no workspace set. Use `render workspace set` to set a workspace", output
  end
end