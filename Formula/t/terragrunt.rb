class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.91.4.tar.gz"
  sha256 "9fec0948f03f5feab6d9ea12becbc7979980dad5b4726b80c8b753bb261ced5d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12e70e8fd68900d78a6a6a27179591717df29d6b9e601ad54c238330ec2cea59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e70e8fd68900d78a6a6a27179591717df29d6b9e601ad54c238330ec2cea59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12e70e8fd68900d78a6a6a27179591717df29d6b9e601ad54c238330ec2cea59"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb0c11df6d143a43b2e7e4f6f48ff9bb111be9581b6cc8efb41777b0758984f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30d38bb705bfa1d7b82580fc0ab113022e61bd27b31a611ee89695026684e940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23e25effcd1044c4a2b36c008dc26a8aaf4c59bbb90ae34b9e77b0fd1a31dd30"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end