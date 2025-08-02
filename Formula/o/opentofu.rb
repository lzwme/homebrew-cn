class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "efa95ba022d05a4cdc983d06007f389bd3ff50557b58309b9a22af52292a589a"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba17d0c0a0745ee891400462c48f11daf74c92013c84efa9f6b10cd45bd5eb61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba17d0c0a0745ee891400462c48f11daf74c92013c84efa9f6b10cd45bd5eb61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba17d0c0a0745ee891400462c48f11daf74c92013c84efa9f6b10cd45bd5eb61"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f613f480da17a68c3072d48e70a412f568de594e93b49a3b5e7f3418079ed89"
    sha256 cellar: :any_skip_relocation, ventura:       "1f613f480da17a68c3072d48e70a412f568de594e93b49a3b5e7f3418079ed89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dd042ebd87611ee32f51a594dfedcd2116db13a570214d0ac10f7e2cf34b461"
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