class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.96.1.tar.gz"
  sha256 "e9b293f9b1b0265f30bdaf565b39a9501b5b07352d856a5da52bcd1a6f4bb217"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25ae42693cf71a829baa2bd908c80f48cd3cf561828906680e5771ceab736277"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25ae42693cf71a829baa2bd908c80f48cd3cf561828906680e5771ceab736277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25ae42693cf71a829baa2bd908c80f48cd3cf561828906680e5771ceab736277"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7b9e36e6e806f60c275921dce257cc32be784b69d033d651ef2cc9bab7f914f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e88aa9e1ca89cb6deaa7aa645fd662309fa038330e9d148d2b722cc5b844c55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8318f0934dc56000afe9a78d5a958ee93f91ea4216d9f11797a588a9794c0698"
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