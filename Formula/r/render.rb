class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://ghfast.top/https://github.com/render-oss/cli/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "a0feb8a4cb8c3a834aaeadbaec49674dc75beca2b846a5530230dd9e12adf391"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9c64b725b25600a97c191144b292544bd65f4caaecd3d089f559f86bd60029d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e9c64b725b25600a97c191144b292544bd65f4caaecd3d089f559f86bd60029d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9c64b725b25600a97c191144b292544bd65f4caaecd3d089f559f86bd60029d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f7d25fb901ebe196e1c0a5c477468c74a09a975be61185b16fc3449b2017e75"
    sha256 cellar: :any,                 x86_64_linux:      "1f95c44f12e7e42d1a8e103997d4b6351a7383aaeb43fbbaf9fe2430623497f9"
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