class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "54c534f3d1df253430cc02220d94b91c1d563e95f040bc24d29a4c45bc197838"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e21bb4a4937783afa2a9b2c85583f0d80f0e98b3e49393cc2127f78c99c9f78f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "566406b46c4db9995246b4a9930e7b1ac34e46a4ae20919b296b5020d653d19d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ab8d2317e661672692489d4d708cfebeb52a5031de3b82a434b6402399d3872"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5df70d936c051d32c5ab6f19976f112ed937a0326d12cb88468ccb7c5bfffdec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6de1bdcd602fe5b9b37f5c3486e1d76e528f4950d94cd29df4a6f8afb2695a81"
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