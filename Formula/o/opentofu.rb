class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.8.0.tar.gz"
  sha256 "9e3f622741a0df00a10fcd42653260742c966936b252d3171d1ad952de6e40e0"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cda604631461cd86599a0b47fa5be2807f719b2d68ae18662cfc8a344fff61a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03f38bc6471247c7cd620cc9a454c2daf970a3dc0e06337237f0675f06d57ec0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "739825e0ac7ae8a2569be686a217db4d924c98dfbefbac747fcf7d4f70cf854d"
    sha256 cellar: :any_skip_relocation, sonoma:         "26a7998f45cb28428ac290b56854885bc85eea45e2e95ee1f0313863f73f37e7"
    sha256 cellar: :any_skip_relocation, ventura:        "ea69759225a9181690acbf1f572d6363476161792551f91fb5614cfeb1f355e8"
    sha256 cellar: :any_skip_relocation, monterey:       "4178f29cd055e53a35991b417ecc14a611423f7e41c6346df8131619b0919a82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "833e26992786ed12be50204ab08ce15665dc45c68737e48324423dbc8089ea4c"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install tofu binary"

  # Needs libraries at runtime:
  # usrlibx86_64-linux-gnulibstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    ldflags = "-s -w -X github.comopentofuopentofuversion.dev=no"
    system "go", "build", *std_go_args(output: bin"tofu", ldflags:), ".cmdtofu"
  end

  test do
    minimal = testpath"minimal.tf"
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

    system bin"tofu", "init"
    system bin"tofu", "graph"
  end
end