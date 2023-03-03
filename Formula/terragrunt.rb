class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.44.2.tar.gz"
  sha256 "e0ebb2d01d03809a36381e0f20778a4f77414f5885b9bedf637860cc6cd92c78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79e0da42adeb16f11fb63080c4aac2e0a62e05bf6c988e369adf4610c8b26065"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e0da42adeb16f11fb63080c4aac2e0a62e05bf6c988e369adf4610c8b26065"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79e0da42adeb16f11fb63080c4aac2e0a62e05bf6c988e369adf4610c8b26065"
    sha256 cellar: :any_skip_relocation, ventura:        "56482d82ff7c975074f77238148ac73aaa318a818bfddbb063e5d3aee614efe2"
    sha256 cellar: :any_skip_relocation, monterey:       "56482d82ff7c975074f77238148ac73aaa318a818bfddbb063e5d3aee614efe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "56482d82ff7c975074f77238148ac73aaa318a818bfddbb063e5d3aee614efe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "128d2a5557fde6c075e4cee7d40efc19a1e9a74bdda2671be63a4af10cd69453"
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