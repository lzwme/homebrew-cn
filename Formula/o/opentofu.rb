class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "fa4927bd08be41775ad6a104414f3fc72ea297a04b80f5601d47479aabd32d3c"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c55ee0d21333abece6ec201e923feb673e2677eb8eff08a859a7cfec8498726"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "437b1cb2a8992ec3440d1e902b12dfcfb857389bf856bd16d0ee51b143a4c8fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24731c600d2a27cf7ab350477f40eb567db58b3336e1f937eb28162f8194d860"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef74bdedd5aea4634d53ae9b4a2595faac0a8ef29ab5fd966b61138e584b403d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c6df5ce2ae9cb2f351d51b0c58531643caa8d2d7e99ccc5d73b647c667af92d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d821bae7e6a059f723210b80e86f4ec1c799a4e42f5a7dfcee90f22bce3c7f12"
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