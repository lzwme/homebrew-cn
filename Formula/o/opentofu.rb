class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "d3584af5204e10910e23198006df0df7af942542207091bb096699ae6dd676cc"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "521f8be6eba8a33b650b1e4a9e17669cb6a1db2ce8bdac3af43de2605b32eeb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54b98e50c68792878d56a97c840d8f29eba51443839697a3ace6e9067698e964"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8f61f9cba84d04140f07a1ede7eb3312d2531bb2c8990ca89857df68cf2c6c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e051f5cf306dc6cb47e21463397e509fb79949cd578a222c412da4e779e1b7b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1559c7287d139940102a2e17767266532fc0c659ff4cb94b36b939300ebc048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e69f806fa3caf4ff586bb2e7b84b478e13718b9e058feb48833077b16809eeb7"
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