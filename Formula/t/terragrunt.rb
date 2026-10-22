class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "dde1831934d7eb2ad309b4be0057d57e10e7fd52ef3f56329346f49077349d4f"
  license "MIT"
  head "https://github.com/gruntwork-io/terragrunt.git", branch: "main"
  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c086970e917ba358c268b919b478cba1a772e6cc26c83734b5574def9bb71eb2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c086970e917ba358c268b919b478cba1a772e6cc26c83734b5574def9bb71eb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c086970e917ba358c268b919b478cba1a772e6cc26c83734b5574def9bb71eb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e64433bf76bf4efd4dfc550b44b8a946323fbefad429cd00ce3d67f3b96532a4"
    sha256 cellar: :any,                 x86_64_linux:      "56d688025bc65e60288689d5f2253b3da07746c8d786a3ca3a99607db216332f"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/gruntwork-io/terragrunt/internal/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end