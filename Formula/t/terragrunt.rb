class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.6.tar.gz"
  sha256 "c80fa12319e01569a90fc92b616cf52fb823d448f43d9c66b9219e700c4371b1"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2e58e6a37c9a882785287777bf3c47ccd7f05dda4ff9e699b8f0b347837773"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2e58e6a37c9a882785287777bf3c47ccd7f05dda4ff9e699b8f0b347837773"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef2e58e6a37c9a882785287777bf3c47ccd7f05dda4ff9e699b8f0b347837773"
    sha256 cellar: :any_skip_relocation, sonoma:        "d670384014713bf386708fcce0bd1fe252657e5ea4056bfbe3b00066b81ea918"
    sha256 cellar: :any_skip_relocation, ventura:       "d670384014713bf386708fcce0bd1fe252657e5ea4056bfbe3b00066b81ea918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "148542dc9513864ddb9ab45f219143a3e65b552f9523ddc299a6d01696faf7ea"
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