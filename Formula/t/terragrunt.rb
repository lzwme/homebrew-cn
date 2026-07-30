class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "d40c45b06becd52c41896b442e90695730c461ce5e1138cf446b8199c61597c2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1eb8ad9a5d287a9347257b7d03250b40fd901292fbaca576cd9a9de0d1ef403"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1eb8ad9a5d287a9347257b7d03250b40fd901292fbaca576cd9a9de0d1ef403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1eb8ad9a5d287a9347257b7d03250b40fd901292fbaca576cd9a9de0d1ef403"
    sha256 cellar: :any_skip_relocation, sonoma:        "c10cd0b5b45ec5668f3bc5d978db7f1274e36606751cabdb06b7d790497d2db5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37e41d57df1226d1687b59e9ac48d5b3671a7c46eac86cc6092b7d0c535aca8f"
    sha256 cellar: :any,                 x86_64_linux:  "873b667cb7cf1d6d50169d7321da0626f592c05f139b02e93737f766ab162ded"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[-X github.com/gruntwork-io/terragrunt/internal/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end