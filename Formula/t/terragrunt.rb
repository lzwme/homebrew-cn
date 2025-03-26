class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.76.8.tar.gz"
  sha256 "e40331e856361486db5ee5f134283da6fde947d6eb1a721fc94a7d6970e1ff88"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d14aed192e4b23ba01c23ac4d794839f451de0ac8bfdce339d2a9eae84fb6ddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d14aed192e4b23ba01c23ac4d794839f451de0ac8bfdce339d2a9eae84fb6ddc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d14aed192e4b23ba01c23ac4d794839f451de0ac8bfdce339d2a9eae84fb6ddc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f4f0fcaf65f55ce997e96f8f7c1dad7d19f8486a454038961661eccfc312b3b"
    sha256 cellar: :any_skip_relocation, ventura:       "8f4f0fcaf65f55ce997e96f8f7c1dad7d19f8486a454038961661eccfc312b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "290d7998eaddb504bb9d2dd4be8481ec3243b50461545f417d5e666d97572da5"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end