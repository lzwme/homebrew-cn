class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "f1e13ed2c1552ea7828156a10588a544d8b6b0d2c25f801a07fdf666734604fd"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f640c15df5b1f652f318b32636b15925c9d1524a585e725eabdff2e15aaa2d18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41d6bf1a886db10154de314f850fa1a07a8c95174f902c7105cc0fdb765e5dac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc6b84168415ac48debb83b0e11d72dde583dfe50c2999ae22adce3042b49bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b7977c866522dea951546ba013188ebc605c3d38d77de0e8b4150cad9a9b9ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01a58d3c1f506d43034bff7e89e71eda4dd2d52733e5cf39cbb4d609584c62b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ff8d70510891e69b7017197d674ce5832da8da3e4b707b004d9fa53cdb23c0d"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags:), "./cmd/tofu"
  end

  test do
    (testpath/"minimal.tf").write <<~HCL
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    HCL

    system bin/"tofu", "init"
    system bin/"tofu", "graph"
  end
end