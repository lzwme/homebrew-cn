class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.91.2.tar.gz"
  sha256 "0ac3bdeef3e6902eeaeb6e90003668b0cfbde1f645a5eaf8e9f88ff51df0af50"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c846553e72c212a1e776a6bcf7dc811e0aefedadc60ad66545d78ace03c57be1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c846553e72c212a1e776a6bcf7dc811e0aefedadc60ad66545d78ace03c57be1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c846553e72c212a1e776a6bcf7dc811e0aefedadc60ad66545d78ace03c57be1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a5f84e6910b2d704db68015bee8807a0c89082d6f2462fbcc8d1d9c53524f9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b100e24c711dc29c16fad7b895267cc59a00987c175f9b48bec0ac8a7d8b75e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9ddcf28fe3ad718ed265b3eacc699058324e45ee6abe77614a4b04088d99445"
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