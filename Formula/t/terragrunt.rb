class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.76.5.tar.gz"
  sha256 "0841c29e3611d4beadd1cd50c9f25a21623f771d8ba77a462aa45c76435c1a67"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e715affa624758a724696d9867fd2dc70af9fd957fcbd4a85958daedaa701fa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e715affa624758a724696d9867fd2dc70af9fd957fcbd4a85958daedaa701fa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e715affa624758a724696d9867fd2dc70af9fd957fcbd4a85958daedaa701fa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e38545e75daee0fdedde4fc16ba5e976fe264a4ea54235236149fcf38a021ab8"
    sha256 cellar: :any_skip_relocation, ventura:       "e38545e75daee0fdedde4fc16ba5e976fe264a4ea54235236149fcf38a021ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "339caf925f005f3c3b6c0c0fab08e0fcb93203d6b3a9c3f5b1d4eecebf7158f9"
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