class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "8fc4016a3764f266f5ae258263710d46590ce1beaabf50ddfffed399f42d0ebd"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8d6f0043d9802f1f55d7c3f9222441a14961f918b8e8acc66ee3fb40d540362"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d338157d0cf3e8987dd69623de59f8dd7eddcd8eef43fcabd65e35e6012f88a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a73a152639c2d28c6f89b311e9f36b0f54d6d3218086e4610cef7548fe33f06"
    sha256 cellar: :any_skip_relocation, sonoma:        "61e86df5b714b66e5e15bfc66f37a73a2662cbfc40d58f7741398e2e26bd69e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4598e493f9106a7195fd597dfca547811bc9f551530033d0a4a890c857590a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3073dda9a8544d1e0cb32481c9e1d9212356584548e8cd77d3963a81bb35e661"
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