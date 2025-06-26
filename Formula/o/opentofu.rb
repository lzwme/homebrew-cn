class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.10.1.tar.gz"
  sha256 "52e3821a7f3fc6a6bf70ba628bf7c9838f05990d47e293558dd494053a66ecde"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63944ff48f4910ccc4b92122d5b1a0480c2d1539aee4cddc514e4167a881d3c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63944ff48f4910ccc4b92122d5b1a0480c2d1539aee4cddc514e4167a881d3c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63944ff48f4910ccc4b92122d5b1a0480c2d1539aee4cddc514e4167a881d3c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "698da1761efdee61452b1480f977d0785eb2ce4ceb816680e514bf9a8b4dfaa1"
    sha256 cellar: :any_skip_relocation, ventura:       "698da1761efdee61452b1480f977d0785eb2ce4ceb816680e514bf9a8b4dfaa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe4fb59e70ec9323ee1264b2b9e7908a020b82fdc966de4c357e67355947b56b"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  def install
    ldflags = "-s -w -X github.comopentofuopentofuversion.dev=no"
    system "go", "build", *std_go_args(output: bin"tofu", ldflags:), ".cmdtofu"
  end

  test do
    minimal = testpath"minimal.tf"
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

    system bin"tofu", "init"
    system bin"tofu", "graph"
  end
end