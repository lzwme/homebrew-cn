class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.3.tar.gz"
  sha256 "8c048308d0d752fd95297b616394fdaf0fa75de27de4edc2303bb34cffe9c6f2"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1590e881832df66e20ce8b4c19718b8eb1772b843d6d24edf19058fa9c3abe2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1590e881832df66e20ce8b4c19718b8eb1772b843d6d24edf19058fa9c3abe2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1590e881832df66e20ce8b4c19718b8eb1772b843d6d24edf19058fa9c3abe2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6d6ad1ec6a30fd50350e05ae25718fbf8024c9b2085a41a68c55891dc0495ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35377bd4a71b273cb5d1258bf044b0dd15cfde7cbf0ab62d5ed888e509b9f85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "668a9c5acaf58b3d693b1a0d3e64112455c75a699dc4fd008eac1f13241897c4"
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