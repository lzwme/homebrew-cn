class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.62.0.tar.gz"
  sha256 "a334c8f2c080930702b77c271c8b2d5e10b1b5f13ca5e3815772f1d16599ae0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e3158b4fb150a3ae5677ad93362ce3547f42f609b02815d56fdf831926f97b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "246f09dee2385a06c5e3569165af3b76352d6f5116502c03f71b63cf8260c438"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db6f5a806739d35d09b77e2cf7dea59834bdb4e4259c4aea74c5fae18485c9a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "916da8babaade6cef561af9cda8188fa1a038e785b29769e687c789e4f893520"
    sha256 cellar: :any_skip_relocation, ventura:        "d98d46c24fa8b682fd39a9e43bb98c777963330c255f1523b5c64bec4ef3763a"
    sha256 cellar: :any_skip_relocation, monterey:       "0951969094ae03e5942c51f8e7c23f5185e58ce9b9743872137f219f337fabdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a55ec56a05278adbdbd2b9999b801714bff69699260b7c54bdfc809ed5da8ee"
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