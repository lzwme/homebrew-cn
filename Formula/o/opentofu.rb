class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "2279dbe3823282b7646d321106b43842203606b4eeddc1a1d3b9de51cdf74953"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8390b1dbccb5409c818f87c2d0ab8629d1c0e2ae1e4f813d3949f40919c595b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8390b1dbccb5409c818f87c2d0ab8629d1c0e2ae1e4f813d3949f40919c595b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8390b1dbccb5409c818f87c2d0ab8629d1c0e2ae1e4f813d3949f40919c595b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "83a50649d70b32d092dd7301b1bd0ad9f11100dabe220d5a391c401e2121adce"
    sha256 cellar: :any_skip_relocation, ventura:       "83a50649d70b32d092dd7301b1bd0ad9f11100dabe220d5a391c401e2121adce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35f2fd86ecc8ad204d5c68cd6e0e928933742e6f4e5ad4274f6516cc62142a68"
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