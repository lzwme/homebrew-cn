class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.1.tar.gz"
  sha256 "ee8836be617784058d1e831e031091fda5ac6502a72d4b5275bf6a5cd097d009"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f784358b889cb03215dbb1bb262eed9e791f90a31fe5308a63d236f88abe910d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f784358b889cb03215dbb1bb262eed9e791f90a31fe5308a63d236f88abe910d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f784358b889cb03215dbb1bb262eed9e791f90a31fe5308a63d236f88abe910d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9553aea9fbf625107b489041bb55664d03033d0bd5b9ef2e6a92141511873487"
    sha256 cellar: :any_skip_relocation, ventura:       "9553aea9fbf625107b489041bb55664d03033d0bd5b9ef2e6a92141511873487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2219b414cf6badaee82244876f3a17b0fee94eb5b9667b1a03e2560d2337a5cf"
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