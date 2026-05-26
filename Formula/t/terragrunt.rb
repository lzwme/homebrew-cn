class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "ecd41d35d794b9d580797590c3dccb1d166812ab21abb87191b190f9c556c7a1"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f49b56d56ba39e8f75970bee45ca3454b06b8ad3846c02856ee46433ad4edf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f49b56d56ba39e8f75970bee45ca3454b06b8ad3846c02856ee46433ad4edf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f49b56d56ba39e8f75970bee45ca3454b06b8ad3846c02856ee46433ad4edf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "eaa11a9ca82c214254c330092f515c4df913e913482853cac58b596adde522ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e4e347f27e4e804e68838b5f20adb800df2939b278b3b9a040a7d0e3b0c2ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74d4d92c452da4b13f90a5715194c538c520a4a021db73a0fc3a143c19d99841"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/terragrunt/internal/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end