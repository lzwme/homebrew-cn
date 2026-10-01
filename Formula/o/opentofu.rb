class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "ef769284412b20eb30b883be10519242ab0c92ea54d8a509261e62ba28da4663"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b1bb97bd33958c8a338493e9da49348284b89a3fca0b622545d5229592aacad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c5c0c59ff50e362826e6df255cf045beb54c6aab9889bb83cb32fef3d28afd9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c6dcee95a60464d0a13d5cb7954af2e216469518ba7a3d801ea8358ba9c36e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8864eab388dde7b85b10ca486e8a1cdeed27f1898c499b10d9eadf9d53a874cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "245d17f70afdf0e23657fc1daf89c5cdcc1c4f2814a398ea1acbf0aff6baf36e"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  # `test do` block downloads a provider from the OpenTofu registry
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-X github.com/opentofu/opentofu/version.dev=no"
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