class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.70.4.tar.gz"
  sha256 "5855dd0b609629dc68f97b9a33bd97950786df3ae8ce1b01f5ae3ee22367365b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3534bf039919e4638af0e947d2d6998850eb95eafa98ba8ec932586a2d610382"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3534bf039919e4638af0e947d2d6998850eb95eafa98ba8ec932586a2d610382"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3534bf039919e4638af0e947d2d6998850eb95eafa98ba8ec932586a2d610382"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bd51a875b3aa1897d9000d1a727a98cc2fbc6497559b188d4d3808dedc3d63a"
    sha256 cellar: :any_skip_relocation, ventura:       "8bd51a875b3aa1897d9000d1a727a98cc2fbc6497559b188d4d3808dedc3d63a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21b0492081ff0ce9582d4b4e9d02f07f4fd3338230e071f13a60fbd030f6d0c8"
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