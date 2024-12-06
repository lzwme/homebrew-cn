class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.8.7.tar.gz"
  sha256 "19aab5182327a42ddaa9718ae608ddadad015c77ad4644bae2f81f3efe28ed90"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61e9a29b56ed63e50afa33fb654b9dcafcaf8510bd20d32a409fcc988ecfdfa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61e9a29b56ed63e50afa33fb654b9dcafcaf8510bd20d32a409fcc988ecfdfa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61e9a29b56ed63e50afa33fb654b9dcafcaf8510bd20d32a409fcc988ecfdfa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f302321e435cc54ffb97706e7466f834159d7bdf289fa4418ebd5a4dbd9c37f8"
    sha256 cellar: :any_skip_relocation, ventura:       "f302321e435cc54ffb97706e7466f834159d7bdf289fa4418ebd5a4dbd9c37f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "403cbca6baad16eeebf08a7c3ca5a48a775fe21de0d368560ff23855c2c25f5e"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  def install
    ldflags = "-s -w -X github.comopentofuopentofuversion.dev=no"
    system "go", "build", *std_go_args(output: bin"tofu", ldflags:), ".cmdtofu"
  end

  test do
    minimal = testpath"minimal.tf"
    minimal.write <<~HCL
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

    system bin"tofu", "init"
    system bin"tofu", "graph"
  end
end