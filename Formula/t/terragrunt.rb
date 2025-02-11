class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.0.tar.gz"
  sha256 "5e717a3a6c9e23cedde6f2821a4c96a25e79121d267cb040ce4b1791664520c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28c5b40ea2e4a782e6ec5342d9957bef389c7a1e83acd8cd91a6e1bb16eb38d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28c5b40ea2e4a782e6ec5342d9957bef389c7a1e83acd8cd91a6e1bb16eb38d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28c5b40ea2e4a782e6ec5342d9957bef389c7a1e83acd8cd91a6e1bb16eb38d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9525b70b713e5cf817b029c765d3c12eb8772608f33b864abfa8246bc54c47d6"
    sha256 cellar: :any_skip_relocation, ventura:       "9525b70b713e5cf817b029c765d3c12eb8772608f33b864abfa8246bc54c47d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fce62d5062db0982ba5b1dad09150d09ff880d3056ce94550b052a3aad86e7ef"
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