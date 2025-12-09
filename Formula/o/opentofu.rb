class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.10.8.tar.gz"
  sha256 "89a4b1c3c20b5512c81c32015b085759412c99e58d2456a3715382b8daa83ff6"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b23376b600a63da842786efbfaeacd259bd0575a542fe41ea100ff6fb100653"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b23376b600a63da842786efbfaeacd259bd0575a542fe41ea100ff6fb100653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b23376b600a63da842786efbfaeacd259bd0575a542fe41ea100ff6fb100653"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8e586092a685f47d77230bdfe82573ef10123aeda5a873f709da3eacf2e3d86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80ede56b6bf2af72c396249bf67b34715d5278d40bf6ed1333a56a548069af22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923ec7ed67463a770014e1cf446b31cf08cec745dcc8f23ccecf622445bbdc9a"
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