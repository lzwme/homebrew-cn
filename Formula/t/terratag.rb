class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://ghfast.top/https://github.com/env0/terratag/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "677c79617ebd7ecf415d87be861e43f3b71b924b78bb461c24124cca13189510"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ea153103f457e9f5aa3fb8cc9e0f46dbfeae0d0ab8732127818e2a56ad6159d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ea153103f457e9f5aa3fb8cc9e0f46dbfeae0d0ab8732127818e2a56ad6159d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ea153103f457e9f5aa3fb8cc9e0f46dbfeae0d0ab8732127818e2a56ad6159d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c845e5b623d7a8203987c642391b75b2d6389e07858ce73105e96b56800b6143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "468d84b6a10ef856e4ae24d28a91588a9da43e685286e5e05b373f81d5a2e6a3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/terratag"
  end

  test do
    (testpath/"main.tf").write <<~HCL
      provider "aws" {
        region = "us-east-1"
      }

      resource "aws_instance" "example" {
        ami           = "ami-12345678"
        instance_type = "t2.micro"
      }
    HCL

    output = shell_output("#{bin}/terratag -dir #{testpath} " \
                          "-tags '{\"environment\":\"test\",\"owner\":\"brew\"}' -rename=false 2>&1", 1)

    assert_match "terraform init must run before running terratag", output
  end
end