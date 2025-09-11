class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.87.1.tar.gz"
  sha256 "d5507f9ebb33a18c102b6d7830e4716479dd18a94732e152e032f0e74c19c80f"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0638e5fae9e54ebdfd70d3639b1b9a4843e03969defbdebd28fb3baec0eb421b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0638e5fae9e54ebdfd70d3639b1b9a4843e03969defbdebd28fb3baec0eb421b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0638e5fae9e54ebdfd70d3639b1b9a4843e03969defbdebd28fb3baec0eb421b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b073f69318e179e36fadb36973dcec0f7a9004971129d4379571ec95b180572"
    sha256 cellar: :any_skip_relocation, ventura:       "3b073f69318e179e36fadb36973dcec0f7a9004971129d4379571ec95b180572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b4bc38143992717b09361f49bbaf6117342d8c6fa6cfa097d1efd99cb8f5db"
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