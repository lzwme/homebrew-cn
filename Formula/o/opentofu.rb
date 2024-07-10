class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.7.3.tar.gz"
  sha256 "c97c470f3afbd30c67a141bb973ad4bcb458d3cd7a6bbe3aad1e99b4fbc026a8"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab487579b6d515d1dde550df2196421dd58f16faf6cf41916eb325bad1356e5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4e5baa5b6a8fc55200276a6dfdf04cca1bf485193d869a80a5c44c37da69946"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb3426187e79327e3428195aa55cb12080b917be8a534583a892b5c13cd2670c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7eaea5e7bd7cdf4218b4be77801de24f8a23957fc502cc89bedca1a2f0178657"
    sha256 cellar: :any_skip_relocation, ventura:        "303aef05ca7aba393b282588eb9968b87c6f746ae17d8f7a58f6e846485e224c"
    sha256 cellar: :any_skip_relocation, monterey:       "f466ad649dd37ff37ef23f7048ea7e1ef0e4c8e1a76cb4cced57e8b871387d53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10fa0fcf14990db73f063d48f2a67778a7ddf7eefb48319040c3297b80bab3b2"
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
    system "#{bin}tofu", "init"
    system "#{bin}tofu", "graph"
  end
end