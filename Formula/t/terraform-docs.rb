class TerraformDocs < Formula
  desc "Tool to generate documentation from Terraform modules"
  homepage "https://terraform-docs.io/"
  url "https://ghfast.top/https://github.com/terraform-docs/terraform-docs/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "e8180d74662707b2643930aee7ba012a29ad767ef55fd3321d6a9f3ce7fa79b8"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e325aa06f0cf53aace520e3818c0b29c6f310d1d21db704a50f59e8a92ae23b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1412944dfbc952119ae641341114703c5f8fa6941a295f2ffad5d77169ff3918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "effe5309b77c590d818d05b80ad62963f0b8106992cf886525670649e0d02b8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "626c6775931d952219907d7ef27ae221d998d5c6a89c7ea05a29bd6a1f98dff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54108f65756d822d1ae1b9d95f2d66a3ac2b0ce9fd8c0b6e795cd1433f52af04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78249117db0046aed56949592d27224f7e6b2c5b8b998fabf3e240489cd66274"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    cpu = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    bin.install "bin/#{os}-#{cpu}/terraform-docs"

    generate_completions_from_executable(bin/"terraform-docs", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"main.tf").write <<~HCL
      /**
       * Module usage:
       *
       *      module "foo" {
       *        source = "github.com/foo/baz"
       *        subnet_ids = "${join(",", subnet.*.id)}"
       *      }
       */

      variable "subnet_ids" {
        description = "a comma-separated list of subnet IDs"
      }

      variable "security_group_ids" {
        default = "sg-a, sg-b"
      }

      variable "amis" {
        default = {
          "us-east-1" = "ami-8f7687e2"
          "us-west-1" = "ami-bb473cdb"
          "us-west-2" = "ami-84b44de4"
          "eu-west-1" = "ami-4e6ffe3d"
          "eu-central-1" = "ami-b0cc23df"
          "ap-northeast-1" = "ami-095dbf68"
          "ap-southeast-1" = "ami-cf03d2ac"
          "ap-southeast-2" = "ami-697a540a"
        }
      }

      // The VPC ID.
      output "vpc_id" {
        value = "vpc-5c1f55fd"
      }
    HCL
    system bin/"terraform-docs", "json", testpath
  end
end