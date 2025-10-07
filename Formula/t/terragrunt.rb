class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.89.0.tar.gz"
  sha256 "a3a519e0dc08f1fb84d89bd9b74f259942c8bf6cf8d7e3fa8d83daf9f0ecfe35"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a31cb158663058bc0c16fcdd7ca3bf021d6e13c6f394dd3e7492b4a31bc9b60c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a31cb158663058bc0c16fcdd7ca3bf021d6e13c6f394dd3e7492b4a31bc9b60c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a31cb158663058bc0c16fcdd7ca3bf021d6e13c6f394dd3e7492b4a31bc9b60c"
    sha256 cellar: :any_skip_relocation, sonoma:        "aedb1f7f43d3720813db03ab4cfd4bafd0af166603d0d769718e0fbbbbcac5bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e8ccef40f877aceaab0fd6b98bc7f51f2c297c7394879138b812e50decddfbf"
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