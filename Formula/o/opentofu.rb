class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.11.4.tar.gz"
  sha256 "89dd393aeae8fe3cbcc8c4813354fb4d06f8ec67c824b85f86b7b24222eb632f"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c7bd1c09d95953c40193e8fcfa65cb79d7e0ea413a1f098476fa923a77c5208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "762ed3109acfad97c0a01a98020879f3ceff79e440e3c8d4f6394fdfe29211fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "192532bd7459c0891faa93b998ef9bb3f8559adf48cab9ecee2d93fc03b96f58"
    sha256 cellar: :any_skip_relocation, sonoma:        "479d9f6f65e36e0750b01bf051fa29d9224915840e7a0448b96713b7640e688d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee0b4f93f1e110a9a18c3fcd175e578d7b03446ca05e5ad750442bde61b724a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a802190b74a9b8e5c95449eb4092b1e7c7c43761b9b303af982faa971fac59df"
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