class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.12.4.tar.gz"
  sha256 "170a9c143a35fe0ef8a9ae02c3bb1585e669f0cd6934da6c421e4cdd4403ffb0"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4280df82c73388edeb500e84cf3b9449a41a876448eda32a0b522157a0f55e51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0c2dc3e5a1872839f6b79572f52c00616282e9c7d354d89fabb0e4f57f07ad5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e1756f1daf715b1c99dc9ae186e7d76a287b7b60bff062d95912fd7e520942e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a50775091965cbca2e1942d9e10a39edcef939e6bb6dc30d9d05eea59ef7ac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4d3cf75c82694bdf940c986817c72c348ef8ead02e0e986209a54243d2b5f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3715f7e188f90d7b1385ecb39f88e7995429af88fc006d7bff8c20d0e887249f"
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