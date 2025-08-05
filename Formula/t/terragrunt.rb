class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.84.1.tar.gz"
  sha256 "54a7b35c93f6bab14afd6c36351f47842f99d3a1718e916b4c63357be9ae0c10"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b5b8a223ca0bac1e62dc679fc29bf2389b9967485cca3eabb706af7c4643999"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b5b8a223ca0bac1e62dc679fc29bf2389b9967485cca3eabb706af7c4643999"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b5b8a223ca0bac1e62dc679fc29bf2389b9967485cca3eabb706af7c4643999"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4fc143a3dd5648095fef48afb768f6c6339b3e342ac6c580683ca8786cd494c"
    sha256 cellar: :any_skip_relocation, ventura:       "e4fc143a3dd5648095fef48afb768f6c6339b3e342ac6c580683ca8786cd494c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114525429d915619becdfaf713cede1b9a99389e685e95c90693406834813ed9"
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