class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.8.8.tar.gz"
  sha256 "c38000df221ad1dfcf773d9b620facaa0f8e5bfb3cbea866faa624474667d51d"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7751aefb6d70d233c066f5897fe717913d1563f719c0a632fb7b94727f749369"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7751aefb6d70d233c066f5897fe717913d1563f719c0a632fb7b94727f749369"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7751aefb6d70d233c066f5897fe717913d1563f719c0a632fb7b94727f749369"
    sha256 cellar: :any_skip_relocation, sonoma:        "315cc5d62d19eeb125bcad720b3418c1f7d54c3f9bca115046bd4674dfbc2b18"
    sha256 cellar: :any_skip_relocation, ventura:       "315cc5d62d19eeb125bcad720b3418c1f7d54c3f9bca115046bd4674dfbc2b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1499a5af1dc0ee46892266a51fe071f32df2778ff74b6bb92347d56910019230"
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