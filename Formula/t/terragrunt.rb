class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.6.tar.gz"
  sha256 "d4fbea779f67f2556d0abf19ec7b12eca11f97700beb15734c105f0ba6f674a9"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e225f361f6247a39a659750b287548ec4e2393252b6a34a3b6dfa35afad6d8f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e225f361f6247a39a659750b287548ec4e2393252b6a34a3b6dfa35afad6d8f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e225f361f6247a39a659750b287548ec4e2393252b6a34a3b6dfa35afad6d8f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "439e969bbd258cb69f12492e3e69038c9adb7cf98c2a39e0ef1753d66fea0501"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f7a29266298957501b6fdbf516ea5d89e54965c513ddbcc728020dafc4d0c8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "988a6c1e985f679d15c6c557c764cfca15f14f83ec6963188f22ed18d51a3ba0"
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