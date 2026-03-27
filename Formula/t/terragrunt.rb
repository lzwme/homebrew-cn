class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.99.5.tar.gz"
  sha256 "372fce15517952639089c259f5fa453fed103a58aec41ca8abe671af75e51fbe"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cf1f09a5a1b4713bbf5bec1693970c1da8bbc5234c0f7ef850ecd79c1d0e0c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf1f09a5a1b4713bbf5bec1693970c1da8bbc5234c0f7ef850ecd79c1d0e0c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf1f09a5a1b4713bbf5bec1693970c1da8bbc5234c0f7ef850ecd79c1d0e0c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d9df1f98f3efa73d1b87b618129c8eadc71522afbe8f04320cf38e5085180c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1697f60baa08f54f1335b752374e737211af733260e44a3d1be8057f4945eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d2a3b74e347d7ae128e6c60a5a52af5fcb9799f0f4b1edb3890011625fc58cc"
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