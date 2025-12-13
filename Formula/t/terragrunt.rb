class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.95.1.tar.gz"
  sha256 "e03bf2e1b6114d7d5c0e0951c5d3d8fdec6c466a1fca23c5b82aba6031c0662d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65f95df88d8412d6b0a9dff2cd97ba11ef81a67a926cc32878ca3d203d13af2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65f95df88d8412d6b0a9dff2cd97ba11ef81a67a926cc32878ca3d203d13af2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65f95df88d8412d6b0a9dff2cd97ba11ef81a67a926cc32878ca3d203d13af2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fab039327fedc71d73de764025adcdeaea644d20c06d4e85bf527c4231bc603"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8a3ba9d1acd43ff3e2012c0844d682ae6ff189d68f39505aaa60ab1b74f1e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01474ae12cbde88f3a9b2922d7ad7fcad06b6336592dcdb674a1f94b97ad6597"
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