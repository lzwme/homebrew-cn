class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "13d96feff7d0cbd47d3bb875ff4ca4f27f871dee98bf7ac32acb8d766cd33dc3"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfc2dca5fde13ea27c5e2499371000ead17b07161c5dc915d40ca488d387588b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cfc2dca5fde13ea27c5e2499371000ead17b07161c5dc915d40ca488d387588b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cfc2dca5fde13ea27c5e2499371000ead17b07161c5dc915d40ca488d387588b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "360c960c0a01f511c6ff0976b0de4c9e790fba8ac4dc2dcbd2fcb1941792dc7d"
    sha256 cellar: :any,                 x86_64_linux:      "caeba6f57bc2034b94ab002f5a1e783f78a556aa174f53e31e6f3e227afbf7ec"
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