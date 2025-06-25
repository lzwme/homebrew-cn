class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.10.0.tar.gz"
  sha256 "2c797b609c97b9398666a3d706f143375ec01634f6fb8f97d503f8be80c9298c"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7220385bc6aa61a0001ff0702f15512215fe83477962f7c893a211b0c49b33b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7220385bc6aa61a0001ff0702f15512215fe83477962f7c893a211b0c49b33b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7220385bc6aa61a0001ff0702f15512215fe83477962f7c893a211b0c49b33b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3345d20052184661419a37e26f5cad7ba859c9e8d0eee2246f975c9cb8ffe957"
    sha256 cellar: :any_skip_relocation, ventura:       "3345d20052184661419a37e26f5cad7ba859c9e8d0eee2246f975c9cb8ffe957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d733c668565619acfdc3e759b401941b0e922bb92ebe126508dbc2587fd562d7"
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