class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.97.0.tar.gz"
  sha256 "de23a03fb4993c1592071d3f1317fa0a06bb9306f4f3b24cf3d4c079b79bcd47"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "815ce07b3bde5e918270697778cff36eb58fac806eef7b27c932d32bd9983dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "815ce07b3bde5e918270697778cff36eb58fac806eef7b27c932d32bd9983dec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "815ce07b3bde5e918270697778cff36eb58fac806eef7b27c932d32bd9983dec"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b7c9f0a5db2b6470c6c736c34048dd729527c84e4a90884ce6e305d8fbe6c99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87ac021373399fa1fc9fd2d89dad5705742bf3b923a13bc0e3c20c99daa1aa2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e3e74c36355bb978e5f87179aa4a5babf5e9e975a6cf7a9b0cf0333f7851c3c"
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