class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.12.0",
      revision: "2481f1fba252da4cf1268b780cbcbb37589ec3cf"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c893e3851c9df4d9003c391b48e5ad6d13e043bf635ec9f16a5d3787260a31d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c893e3851c9df4d9003c391b48e5ad6d13e043bf635ec9f16a5d3787260a31d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c893e3851c9df4d9003c391b48e5ad6d13e043bf635ec9f16a5d3787260a31d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b12a1dbb4c5feb03e5b84678f5c3c7055a1e169c35a068bc7d8d2b22949e377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0a2f573c3cd284e0340caff44a5f273a7d443fcde932c7d47eee3c473ba0d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b5e492747a3a43c2faaeef0b46adc17517d86ceffed87fb0f4210b94604dbe9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end