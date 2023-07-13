class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://ghproxy.com/https://github.com/hashicorp/terraform/archive/v1.5.3.tar.gz"
  sha256 "fb2e8e39a3d0db084193090e9039704817fe4a29e231288b7c1605d9521121e2"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a3e955ec78a0f8b155bdfc157a7faa4b04822de7a625f3af023559bba8c630a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a3e955ec78a0f8b155bdfc157a7faa4b04822de7a625f3af023559bba8c630a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a3e955ec78a0f8b155bdfc157a7faa4b04822de7a625f3af023559bba8c630a"
    sha256 cellar: :any_skip_relocation, ventura:        "cdf10edf86be80f1642a2ad2b3e1074e5480fb449d036f7a343ada663175df5d"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf10edf86be80f1642a2ad2b3e1074e5480fb449d036f7a343ada663175df5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdf10edf86be80f1642a2ad2b3e1074e5480fb449d036f7a343ada663175df5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25dd2a7a19de26dda0839666038c37548ad81235883fe116f580495bddade969"
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