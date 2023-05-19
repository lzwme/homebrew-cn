class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.45.14.tar.gz"
  sha256 "0e8586fee59d18edf9fb48ba837ec7bb9963fe07a6833579f8a4dbc80449683d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f023ef7fef23a2ee4c393646a02cacf3814ccfb32bfdea95d389614f70ffc6eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f023ef7fef23a2ee4c393646a02cacf3814ccfb32bfdea95d389614f70ffc6eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f023ef7fef23a2ee4c393646a02cacf3814ccfb32bfdea95d389614f70ffc6eb"
    sha256 cellar: :any_skip_relocation, ventura:        "4ecb82e944a8da781940f4ac13e06ad0289afdadfabbb430fcdbd9c47de0c87d"
    sha256 cellar: :any_skip_relocation, monterey:       "4ecb82e944a8da781940f4ac13e06ad0289afdadfabbb430fcdbd9c47de0c87d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ecb82e944a8da781940f4ac13e06ad0289afdadfabbb430fcdbd9c47de0c87d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd151b7d5e701b76bc476bc11c0d136cd0d828bcba7452904e5768b7ad701f1"
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