class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.86.2.tar.gz"
  sha256 "2c6e9d1548708560a5b8bd5ad5dc5087faf9135323347df29ff5c1e498e7b869"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7fa9fd9c54683b85cb766756676112f2e9830705c0f6fc89fbceb4cd67be4bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7fa9fd9c54683b85cb766756676112f2e9830705c0f6fc89fbceb4cd67be4bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7fa9fd9c54683b85cb766756676112f2e9830705c0f6fc89fbceb4cd67be4bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8ee7b73858ac2fa9b91a7b6a7a20a4a3f8ef8d177e3ef2a23a73e74796cc380"
    sha256 cellar: :any_skip_relocation, ventura:       "d8ee7b73858ac2fa9b91a7b6a7a20a4a3f8ef8d177e3ef2a23a73e74796cc380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a58720979f87a06e7f96b43a74a7994e47be037460174f89208f897d48846fe2"
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