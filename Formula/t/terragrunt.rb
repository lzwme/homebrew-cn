class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.99.0.tar.gz"
  sha256 "6af2b36aee1223365b25e2bbfe52a467503db9162866fff552e1c31029698a14"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9db7a93b97f0845facb2791fa82a9c938d29cfd1edad9034d20cb656f8b419ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9db7a93b97f0845facb2791fa82a9c938d29cfd1edad9034d20cb656f8b419ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9db7a93b97f0845facb2791fa82a9c938d29cfd1edad9034d20cb656f8b419ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "219e5969cf1273ad0e50e6c594044cda2eb1a3546e3d6c83e3be811fbefd0a13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7746af83fc81ae1f27558a2b2eb69709952469090dfdb5d8a4575ef8a584737a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "353d20cb122e2c1eddd1c9528d19d746150f41381dbeefc31f81719a31e36404"
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