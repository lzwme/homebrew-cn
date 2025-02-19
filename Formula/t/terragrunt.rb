class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.7.tar.gz"
  sha256 "8d934db115722c801b0a522bddfd14616b6c64dc689be3ea0ecda170b521e0b3"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8f4d8735b47eba96ae34009d2d62161266b176e00a780909d3f77521ed0ab4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8f4d8735b47eba96ae34009d2d62161266b176e00a780909d3f77521ed0ab4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8f4d8735b47eba96ae34009d2d62161266b176e00a780909d3f77521ed0ab4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1b365ce0a50ffe6bb9a4baca40f35d584e8a0b88a8111403e9123c196ac7722"
    sha256 cellar: :any_skip_relocation, ventura:       "b1b365ce0a50ffe6bb9a4baca40f35d584e8a0b88a8111403e9123c196ac7722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e86619975adff5a6a18f9380d8c2e7a8364391328d8b460e62a8cf3cbf6e8d8"
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