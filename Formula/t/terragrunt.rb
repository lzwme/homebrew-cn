class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.11.tar.gz"
  sha256 "00f92f71a604665d51fb9163a79974d3a052df6767f179d676796ce6fbeac5b9"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f3741c34a75ed052cd212d5edeb8bb1d8bd1c34ef919a0eeb07ef2b1bb62a9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f3741c34a75ed052cd212d5edeb8bb1d8bd1c34ef919a0eeb07ef2b1bb62a9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f3741c34a75ed052cd212d5edeb8bb1d8bd1c34ef919a0eeb07ef2b1bb62a9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "267603276c76b0da76f9a0f074958dee0177cf974124dfb1b14c4ae4e3eca41d"
    sha256 cellar: :any_skip_relocation, ventura:       "267603276c76b0da76f9a0f074958dee0177cf974124dfb1b14c4ae4e3eca41d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b79faca08ab5ca2bcf68c32acfc6ef07eb83f8e129fb4571617b2813d49066"
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