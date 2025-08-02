class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.84.0.tar.gz"
  sha256 "24548f0aca35efe4c8d3700658b7e3da89165a03895112949e12805f00908e62"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55014d407cee1949238203fd454dd1b3f6b5d9691dd252b39e53f0d725758779"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55014d407cee1949238203fd454dd1b3f6b5d9691dd252b39e53f0d725758779"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55014d407cee1949238203fd454dd1b3f6b5d9691dd252b39e53f0d725758779"
    sha256 cellar: :any_skip_relocation, sonoma:        "baee4087d0092d70c57bd429c85bbe3e77b4ece98602d6e05ee6c6319e7e1088"
    sha256 cellar: :any_skip_relocation, ventura:       "baee4087d0092d70c57bd429c85bbe3e77b4ece98602d6e05ee6c6319e7e1088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9479dc0f8ce2ae5b4c1897c8e950e0be2edb31426df5cfc46b458f1246bb9bc7"
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