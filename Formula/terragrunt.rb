class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.48.5.tar.gz"
  sha256 "fcdfc3a7a1e30dcd457f807d2f3064005e7b7eb66012b8df1468539e9a9e3102"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b57ffb15e0a395a97f95bf486a9728f0c5b6bc8e4c0add9a2f0eca457cf34fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b57ffb15e0a395a97f95bf486a9728f0c5b6bc8e4c0add9a2f0eca457cf34fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b57ffb15e0a395a97f95bf486a9728f0c5b6bc8e4c0add9a2f0eca457cf34fa"
    sha256 cellar: :any_skip_relocation, ventura:        "ae90ccb5bffc22f26f39fea4a8fa38d0bbd7be46065896e3e350a27e6ac58570"
    sha256 cellar: :any_skip_relocation, monterey:       "ae90ccb5bffc22f26f39fea4a8fa38d0bbd7be46065896e3e350a27e6ac58570"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae90ccb5bffc22f26f39fea4a8fa38d0bbd7be46065896e3e350a27e6ac58570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab0ad01921628c128f702d5849d293e31c88486edc73aed8db0a6d3a4e4ce75"
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