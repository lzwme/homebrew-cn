class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.9.tar.gz"
  sha256 "c99e7eb999996b759b1937ab70c55f585fd94b20d0ca47e649e631c1cf6478f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e4a62fb9f20e211ec584b07a6dcca241990fa15f29b0895f12e71d9dac5b926"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e4a62fb9f20e211ec584b07a6dcca241990fa15f29b0895f12e71d9dac5b926"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e4a62fb9f20e211ec584b07a6dcca241990fa15f29b0895f12e71d9dac5b926"
    sha256 cellar: :any_skip_relocation, sonoma:        "62561868b7df1af1f711c284a5c95c63badd52c7d9339620f0a0b4730731d65d"
    sha256 cellar: :any_skip_relocation, ventura:       "62561868b7df1af1f711c284a5c95c63badd52c7d9339620f0a0b4730731d65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b518c5264f0f010e6d484084b2dfc6f9edcb304d7c13b43eb077089133180dc"
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