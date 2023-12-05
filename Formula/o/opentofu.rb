class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghproxy.com/https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-beta2.tar.gz"
  sha256 "d533354f9bdef81acd4620bc6662d6810f4bbe2b32936b6c32acd35d59f6307c"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  # This uses a loose regex, so it will match unstable versions for now. Once a
  # stable version becomes available, we should update or remove this to ensure
  # we only match stable versions going forward.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+.*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "872afa2fe54405471b9ef8db43d3986da19074b0f6357d0a8eb3d4c940ac2992"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3debffc1a0d6f09a65393f35eb12303bf6ec494e5e1bcf65957fd73ec6e61cc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3586c20dcb19d1f5b310f09b61a8f1696068447488235ea97beae9d3dd8e1b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "016a2bedd74680f7fc0c568f4663ae1214a7cb77770ec672ff7c3c978e452eb7"
    sha256 cellar: :any_skip_relocation, ventura:        "ce0f7e69bc1b26f95183d962f3d6133c76a157786f1554f8cab309df859134f2"
    sha256 cellar: :any_skip_relocation, monterey:       "f87dc0d19ff5aa58f7999bd1293f7464bc5b04077c717567929b35df2c29642f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "028506691cb8bb18b770358c3dfeb663612362c61df1ba2fb2decb58bfa6859b"
  end

  depends_on "go" => :build

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags: "-s -w"), "./cmd/tofu"
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
    system "#{bin}/tofu", "init"
    system "#{bin}/tofu", "graph"
  end
end