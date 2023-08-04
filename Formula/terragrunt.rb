class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.48.6.tar.gz"
  sha256 "f62888e4e86360b4d6f61b8e415fd1e8ba7a0b177f6cb2bcb15e47e3b1f3faec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "204f714c84fd11546db91d7a26df360daceebbc5a742124b7bede3e7adaa2300"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204f714c84fd11546db91d7a26df360daceebbc5a742124b7bede3e7adaa2300"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "204f714c84fd11546db91d7a26df360daceebbc5a742124b7bede3e7adaa2300"
    sha256 cellar: :any_skip_relocation, ventura:        "2459173dc5f3ed6012651ec2dee5240fd1f3aac59a2d97dd19a046048deb4ab5"
    sha256 cellar: :any_skip_relocation, monterey:       "2459173dc5f3ed6012651ec2dee5240fd1f3aac59a2d97dd19a046048deb4ab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2459173dc5f3ed6012651ec2dee5240fd1f3aac59a2d97dd19a046048deb4ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef577cbe3f8937f36e79e9d4a1f10c010c8bc222d108ad1777b011ce609bc262"
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