class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.8.6.tar.gz"
  sha256 "ee1ffaf26b4849dfcfbbc896624c7fafdc4982ad60bc2fa3b0826d0dfd2ef7f7"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64a7f00283a93d2f592d7551df8436ef32e72986285253ffa1913cbb500b07fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64a7f00283a93d2f592d7551df8436ef32e72986285253ffa1913cbb500b07fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64a7f00283a93d2f592d7551df8436ef32e72986285253ffa1913cbb500b07fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3404c3ba62028182a3f71d074aba95932dda55e93780f0e54b210a0cddd4c4bd"
    sha256 cellar: :any_skip_relocation, ventura:       "3404c3ba62028182a3f71d074aba95932dda55e93780f0e54b210a0cddd4c4bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56b6687d5d9164fb2c5fa197f283d37d605ed4ad810a42d3eb8950ab1db79794"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

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