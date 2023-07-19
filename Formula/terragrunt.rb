class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.48.3.tar.gz"
  sha256 "efa40d7cf198f00d2cc7ecb80904fd1ababe5be95ed53ada5e650817630e48dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4def3693a730dc512f730b6ea099d5872da7753f69f9375a1c497bc30a62aefc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4def3693a730dc512f730b6ea099d5872da7753f69f9375a1c497bc30a62aefc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4def3693a730dc512f730b6ea099d5872da7753f69f9375a1c497bc30a62aefc"
    sha256 cellar: :any_skip_relocation, ventura:        "93654ccfbf01a89371213b478f577c054ad8139b4940b3ef6148e787c4f5a663"
    sha256 cellar: :any_skip_relocation, monterey:       "93654ccfbf01a89371213b478f577c054ad8139b4940b3ef6148e787c4f5a663"
    sha256 cellar: :any_skip_relocation, big_sur:        "93654ccfbf01a89371213b478f577c054ad8139b4940b3ef6148e787c4f5a663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04462a8416fe1cfec125fba2d440e7331f7cd5a3383e820900d18e5db0d64bed"
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