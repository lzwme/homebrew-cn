class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.66.9.tar.gz"
  sha256 "853b132e85542db86d69c9738f856d8fda3d76d56614a16d99b333a947d4e915"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4dffc0c6d20bca944c71e2fe79a6f3fbcb22c279ae8fb6b82e1859455587b3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4dffc0c6d20bca944c71e2fe79a6f3fbcb22c279ae8fb6b82e1859455587b3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4dffc0c6d20bca944c71e2fe79a6f3fbcb22c279ae8fb6b82e1859455587b3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2e72603fa62fd27fa8ff282ac7852bb043a25baa4f5d7cd4c2e4cb04b0fd52d"
    sha256 cellar: :any_skip_relocation, ventura:        "e2e72603fa62fd27fa8ff282ac7852bb043a25baa4f5d7cd4c2e4cb04b0fd52d"
    sha256 cellar: :any_skip_relocation, monterey:       "e2e72603fa62fd27fa8ff282ac7852bb043a25baa4f5d7cd4c2e4cb04b0fd52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33d7386f3dd434149729dba5e5442cf85a1a8b06f543e6f46496005a6c743457"
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