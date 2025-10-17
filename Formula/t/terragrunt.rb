class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.91.1.tar.gz"
  sha256 "85d37256d396484f0b4169b9c0cab15000156daea411b5696eeccca227db08b4"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d309af208e886d868a86acaac71bf6c17f55c64cc1905ceabc75f5f1133464c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d309af208e886d868a86acaac71bf6c17f55c64cc1905ceabc75f5f1133464c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d309af208e886d868a86acaac71bf6c17f55c64cc1905ceabc75f5f1133464c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cdd9e3854cfbcc5874458174f3610447e129bde335668114afa72702b1fb02d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f0285d1541133e45f68d079d54fbf03e81af169c27fe96b5b9b97c11c87b545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "856f825c99ef83b6df874132a72c90d73701abccb497fe4391b86d72342a2078"
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