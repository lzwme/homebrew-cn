class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.33.11.tar.gz"
  sha256 "554840cde5df5b1120f94a65e1e61853f8b55dc2164271ca73365409d176f037"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bddc622719765a4a847b399d2c3fe03643ed59044f16aa19dadcdfa49fcc3816"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7850aa3e4901845e2d99970c3047aa162a0d06427021506e2ab2135c9aa601f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d86d0c3775dd7d2045c9df2b4767dac71b302f9ba666660e7bf86f71e547f688"
    sha256 cellar: :any_skip_relocation, sonoma:        "1602bdc46dd513089a4006a77dc2d1a0a5e7a12124f5c9009b4b11bc37a8974b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ed75efde037d367f3302e286e9807881b62e21062b11fcdde50939d7602533"
    sha256 cellar: :any,                 x86_64_linux:  "f606f9c066e47b63f79a46c51f01b77dded2a1a4b29a6cf815927a7f1ac5a347"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end