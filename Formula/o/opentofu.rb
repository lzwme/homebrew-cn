class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.10.2.tar.gz"
  sha256 "442d51e0595e79a3eceb84d8a2891e691f7277d0da7dd34f87836692d4aeca91"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2decc3b3b8a2e791a3586de8084f74d823ccdbc7e5a2b6d2d1a57ea5dff9755d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2decc3b3b8a2e791a3586de8084f74d823ccdbc7e5a2b6d2d1a57ea5dff9755d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2decc3b3b8a2e791a3586de8084f74d823ccdbc7e5a2b6d2d1a57ea5dff9755d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e8a6bba352cdbddd4bcc6dc961c3dc8606ac1b6a3c24dae62e877211bafd7ff"
    sha256 cellar: :any_skip_relocation, ventura:       "4e8a6bba352cdbddd4bcc6dc961c3dc8606ac1b6a3c24dae62e877211bafd7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95a066272d12aa9483a96440a0072dfa6ff9b226e150564a54d3851f771f2a3b"
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