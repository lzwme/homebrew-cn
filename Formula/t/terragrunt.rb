class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.15.tar.gz"
  sha256 "b88b01a4da72468f5d8e40cc29e60ec09c283bff012e90da246b4dba2654053e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6838f4ce8908cd1e693cfe898327073ef213781f08cb44fa3486a4462a5ba05e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6838f4ce8908cd1e693cfe898327073ef213781f08cb44fa3486a4462a5ba05e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6838f4ce8908cd1e693cfe898327073ef213781f08cb44fa3486a4462a5ba05e"
    sha256 cellar: :any_skip_relocation, sonoma:        "29b9a49c806fa3e8a074735ad6a911814bb7a82e0f385f49225a20136f5a4b0e"
    sha256 cellar: :any_skip_relocation, ventura:       "29b9a49c806fa3e8a074735ad6a911814bb7a82e0f385f49225a20136f5a4b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f7796b1e08eb58dfe215e3416e7aa837630e8261212cf61b6ac2d4f6b2a7b25"
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