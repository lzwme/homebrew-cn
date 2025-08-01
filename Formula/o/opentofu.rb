class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "bd985f2ea72bd3c65ff382bf7c1406d8a0791acfa7afcf89dd71b432367f470e"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf8dc86e2e7606f89066f0f8f7554b8c4b10d003ee383c23e982e7dd411149f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf8dc86e2e7606f89066f0f8f7554b8c4b10d003ee383c23e982e7dd411149f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf8dc86e2e7606f89066f0f8f7554b8c4b10d003ee383c23e982e7dd411149f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb3351a9c67771307cc5f58cb1c2e105b2dfd3ab780dc97a09094f45429115e1"
    sha256 cellar: :any_skip_relocation, ventura:       "cb3351a9c67771307cc5f58cb1c2e105b2dfd3ab780dc97a09094f45429115e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b04f190a3634436f8bc10ccaad25d5eed04820710374d87024d1ad4986145d42"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  def install
    ldflags = "-s -w -X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags:), "./cmd/tofu"
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~HCL
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