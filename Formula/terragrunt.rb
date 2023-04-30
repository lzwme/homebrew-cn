class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.45.6.tar.gz"
  sha256 "67f01f772926c1e0e06125e125d7e0aeab606435903bc2451decf602f3e54fd9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "125719a60761c73cb01273187697e3c41fefc10c041b642869e8a3298f289ed7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "125719a60761c73cb01273187697e3c41fefc10c041b642869e8a3298f289ed7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "125719a60761c73cb01273187697e3c41fefc10c041b642869e8a3298f289ed7"
    sha256 cellar: :any_skip_relocation, ventura:        "8dba5a5d7970732eb17edd0a8924ac922ceb89f21f8e0b609f028a5a37391f89"
    sha256 cellar: :any_skip_relocation, monterey:       "8dba5a5d7970732eb17edd0a8924ac922ceb89f21f8e0b609f028a5a37391f89"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dba5a5d7970732eb17edd0a8924ac922ceb89f21f8e0b609f028a5a37391f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1533dd2443f584966f3b5f381da3450a55f4ffd5950a42c93526fa9b7a6c7f5"
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