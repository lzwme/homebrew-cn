class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.45.13.tar.gz"
  sha256 "05f1c02507c93fe4f0e4a5bac5f794234e8310b72ece1fe8ebd01a3a1f352f5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "685454fc00e2b6606b6c7a1f4c8c9aa9d483aa6a2cecbe4a8c94c3e6f91df33c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "685454fc00e2b6606b6c7a1f4c8c9aa9d483aa6a2cecbe4a8c94c3e6f91df33c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "685454fc00e2b6606b6c7a1f4c8c9aa9d483aa6a2cecbe4a8c94c3e6f91df33c"
    sha256 cellar: :any_skip_relocation, ventura:        "4de20b6916d8ce2505a3cbdab2ae5fe906cfb729de151526ff81579130ed6935"
    sha256 cellar: :any_skip_relocation, monterey:       "4de20b6916d8ce2505a3cbdab2ae5fe906cfb729de151526ff81579130ed6935"
    sha256 cellar: :any_skip_relocation, big_sur:        "4de20b6916d8ce2505a3cbdab2ae5fe906cfb729de151526ff81579130ed6935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a60f4550aa227474146a652826e12a8d02e866483900c90fc7a3209a4313c2c"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end