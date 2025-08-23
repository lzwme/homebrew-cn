class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.86.0.tar.gz"
  sha256 "c41dbcbdebe133708e85ceda2642109b9e5386c941f1e5b06401ccf9147e8ab8"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22d71bbf7d1bb0bf29de649b06b5e48894645bdf76bfbc1e67f49d84561c62ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22d71bbf7d1bb0bf29de649b06b5e48894645bdf76bfbc1e67f49d84561c62ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22d71bbf7d1bb0bf29de649b06b5e48894645bdf76bfbc1e67f49d84561c62ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "a051fc49c3c09e9b8193a78d1644722ef66e812e3d4fc98b51830e548fcbeee8"
    sha256 cellar: :any_skip_relocation, ventura:       "a051fc49c3c09e9b8193a78d1644722ef66e812e3d4fc98b51830e548fcbeee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68eeee7563f902175d03a132ed50b7aec291a2910e0077fcb73e089a07bd81c2"
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