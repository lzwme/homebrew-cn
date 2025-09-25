class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.87.6.tar.gz"
  sha256 "a9c8cfc9fb89b6e0e6ce85d8cfd388bed2f7bb85d1aa57a6db4b9db5754fa988"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf8376aa8bc756dc20ccdd0d9c775fef6037e343b472180ccfec532d82dfe00d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf8376aa8bc756dc20ccdd0d9c775fef6037e343b472180ccfec532d82dfe00d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf8376aa8bc756dc20ccdd0d9c775fef6037e343b472180ccfec532d82dfe00d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a89444caa4c275384b7cd9fc5def7effcf6f68c78ef6305785db72caf764b385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc182fa04447671daee285e194cdc0dfde446e165e6eb0f87a4d15238aa43c8"
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