class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://ghproxy.com/https://github.com/hashicorp/terraform/archive/v1.5.4.tar.gz"
  sha256 "7a2dce5babc8a93cd7dfd5e4c59bacdd1f09776c7fa9152f7f7e4c9f2a714a71"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c7c39b1404a1ad733e4a9c2e81336637870452508733053ec5499c55faa6ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c7c39b1404a1ad733e4a9c2e81336637870452508733053ec5499c55faa6ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89c7c39b1404a1ad733e4a9c2e81336637870452508733053ec5499c55faa6ba"
    sha256 cellar: :any_skip_relocation, ventura:        "113fb0eef0065f84c5a9d3d919f184713eb54a730c902750a1f7344e13aeb925"
    sha256 cellar: :any_skip_relocation, monterey:       "113fb0eef0065f84c5a9d3d919f184713eb54a730c902750a1f7344e13aeb925"
    sha256 cellar: :any_skip_relocation, big_sur:        "113fb0eef0065f84c5a9d3d919f184713eb54a730c902750a1f7344e13aeb925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72c8e4c7030dc4dc07c13146bae090b25fb8ccc016afeccb5efa2421501092f3"
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