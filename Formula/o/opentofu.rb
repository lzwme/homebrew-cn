class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.8.5.tar.gz"
  sha256 "07613c3b7d6c0a7c3ede29da6a4f33d764420326c07a1c41e52e215428858ef4"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a31903643d97f9f9acb2832dd67304905b90d89a2e1c7764d6c966af9b0c5f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a31903643d97f9f9acb2832dd67304905b90d89a2e1c7764d6c966af9b0c5f51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a31903643d97f9f9acb2832dd67304905b90d89a2e1c7764d6c966af9b0c5f51"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d5581383f4a84d4fefdf0dc6abbd6f42853a68afc67bc4270ad4bfa1e4c8b04"
    sha256 cellar: :any_skip_relocation, ventura:       "0d5581383f4a84d4fefdf0dc6abbd6f42853a68afc67bc4270ad4bfa1e4c8b04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f255b92ecc2ea4483fb972c8a61551033f249811c53c0dfef4bfbc77134f866"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  # Needs libraries at runtime:
  # usrlibx86_64-linux-gnulibstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    ldflags = "-s -w -X github.comopentofuopentofuversion.dev=no"
    system "go", "build", *std_go_args(output: bin"tofu", ldflags:), ".cmdtofu"
  end

  test do
    minimal = testpath"minimal.tf"
    minimal.write <<~EOS
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
    EOS

    system bin"tofu", "init"
    system bin"tofu", "graph"
  end
end