class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://ghproxy.com/https://github.com/hashicorp/terraform/archive/v1.4.1.tar.gz"
  sha256 "338a6d1f13d27c8c5666d0b91649e2a923cc1204a8d33cb29a126cc8a7bd064d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d8a2cf96386c5d2c151c742925814f8429873d8b673d8e1b1d1476dc16437f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d8a2cf96386c5d2c151c742925814f8429873d8b673d8e1b1d1476dc16437f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d8a2cf96386c5d2c151c742925814f8429873d8b673d8e1b1d1476dc16437f4"
    sha256 cellar: :any_skip_relocation, ventura:        "b1d5000c12c2df58262cf736c3309b372751d0b73dae3eee89ec95f85512fa87"
    sha256 cellar: :any_skip_relocation, monterey:       "b1d5000c12c2df58262cf736c3309b372751d0b73dae3eee89ec95f85512fa87"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1d5000c12c2df58262cf736c3309b372751d0b73dae3eee89ec95f85512fa87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7793fde8f830b74dcb992796d55f8c633a2c2e32cf034e630a85e53b2dac13e"
  end

  depends_on "go" => :build

  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    minimal = testpath/"minimal.tf"
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
    system "#{bin}/terraform", "init"
    system "#{bin}/terraform", "graph"
  end
end