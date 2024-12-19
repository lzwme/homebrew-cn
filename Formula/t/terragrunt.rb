class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.70.3.tar.gz"
  sha256 "b857bee8c007f54a5a7f73f2ce68f07c87b9e0578203d75d1b8478a3467952a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e16bb1cc4c8122f336033d5d2ff3cad542462d4389dfe67b5d043fd78a3ff0d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e16bb1cc4c8122f336033d5d2ff3cad542462d4389dfe67b5d043fd78a3ff0d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e16bb1cc4c8122f336033d5d2ff3cad542462d4389dfe67b5d043fd78a3ff0d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5376c161523dd1e4ca0d21d80dbfa15f14822fa879782e9c216e86b82377e515"
    sha256 cellar: :any_skip_relocation, ventura:       "5376c161523dd1e4ca0d21d80dbfa15f14822fa879782e9c216e86b82377e515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a184066917baf45e3023f98a6c3c2ec21fb72798cd6f410c46e9c28c81fd2ea8"
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