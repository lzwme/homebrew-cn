class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.87.2.tar.gz"
  sha256 "faaeaa8fe7f4f96ec16541346cb51c39a1d9c95393b7f0df273b41c8c682ca0a"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a46dc911d0dfe2953cb445c704ed9f82c5a3646cdc8d14b7a77dd45de2eebe08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46dc911d0dfe2953cb445c704ed9f82c5a3646cdc8d14b7a77dd45de2eebe08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a46dc911d0dfe2953cb445c704ed9f82c5a3646cdc8d14b7a77dd45de2eebe08"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2968dc7776791eeb4a486e13260317555a08d5a92cac7946f79a96653fa374b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf601514f98b7973550f5c53a619862d5e25fe9db12e849be23fc8bfa4ead6a2"
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