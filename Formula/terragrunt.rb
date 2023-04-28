class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.45.5.tar.gz"
  sha256 "f72ea470f8f81439fee6027ecb258b8bcf1670ae4f6284d067a1828c4f773469"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1d7285fb98c6bbc44ce24bfaa32fe14ee84efab1b3134f4db8d28e0ea0be4cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1d7285fb98c6bbc44ce24bfaa32fe14ee84efab1b3134f4db8d28e0ea0be4cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1d7285fb98c6bbc44ce24bfaa32fe14ee84efab1b3134f4db8d28e0ea0be4cf"
    sha256 cellar: :any_skip_relocation, ventura:        "4e31a6ed1d16fc1817346af828cbf54b35e097369adb39a82c4af495ef8d25bb"
    sha256 cellar: :any_skip_relocation, monterey:       "4e31a6ed1d16fc1817346af828cbf54b35e097369adb39a82c4af495ef8d25bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e31a6ed1d16fc1817346af828cbf54b35e097369adb39a82c4af495ef8d25bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86f677ce607392d3af78c55a398a55bf3b39008824343003e48d8ee3732e3662"
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