class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.8.4.tar.gz"
  sha256 "89eb05e7ed1b20e3d0c799758b2cfc8d6dc212e8a09b20d9eaf03017be4d74e6"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dea327dea9b167df7183f6c756a4834603b704bf0392e88a3ea8c1a25edff6ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dea327dea9b167df7183f6c756a4834603b704bf0392e88a3ea8c1a25edff6ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dea327dea9b167df7183f6c756a4834603b704bf0392e88a3ea8c1a25edff6ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "21d40f47e42e227255c94d84b715c1a406b49afe5e0b140cca8fc64eee3bbd14"
    sha256 cellar: :any_skip_relocation, ventura:       "21d40f47e42e227255c94d84b715c1a406b49afe5e0b140cca8fc64eee3bbd14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea4be6b4ae8cad01e010514712826ded9740b861684ca1c34af97491b8fb8b66"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

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