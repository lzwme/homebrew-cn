class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://ghproxy.com/https://github.com/hashicorp/terraform/archive/v1.5.1.tar.gz"
  sha256 "c0e445ffacd3ecd7da0cc7329774649c844e7a012c50219057c1561bcc870df2"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/terraform/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72fc13ad83f9aab7eed7d5a0f641df133343747030860d760d11a3a5ecdb6d0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72fc13ad83f9aab7eed7d5a0f641df133343747030860d760d11a3a5ecdb6d0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72fc13ad83f9aab7eed7d5a0f641df133343747030860d760d11a3a5ecdb6d0c"
    sha256 cellar: :any_skip_relocation, ventura:        "a36ea9a904a278182f9a893cb66436ea239b340cc820abfa63493e25624c76a5"
    sha256 cellar: :any_skip_relocation, monterey:       "a36ea9a904a278182f9a893cb66436ea239b340cc820abfa63493e25624c76a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a36ea9a904a278182f9a893cb66436ea239b340cc820abfa63493e25624c76a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1297bf4a6decc01f8e7c9292d3d58ef1080d12cd7a529a8f4741e0161086911f"
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