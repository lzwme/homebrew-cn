class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.8.2.tar.gz"
  sha256 "8e3963f1054a46e81ee0b008b3e3a3cba5a8d7718c036ef2ff0fc56670a9bff4"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e037af85fb9b97931d4ce00e6e78900f845f82c85ff9247751969394b855a807"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f21bd3d331f36ee695233d8cbcf7f6892aa66f084dd1366534b98080375fcaca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f21bd3d331f36ee695233d8cbcf7f6892aa66f084dd1366534b98080375fcaca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f21bd3d331f36ee695233d8cbcf7f6892aa66f084dd1366534b98080375fcaca"
    sha256 cellar: :any_skip_relocation, sonoma:         "85ef5702b8f8fec1c73fd48083b7c72b14a02b86a69c3edb80e1af46dda11aae"
    sha256 cellar: :any_skip_relocation, ventura:        "85ef5702b8f8fec1c73fd48083b7c72b14a02b86a69c3edb80e1af46dda11aae"
    sha256 cellar: :any_skip_relocation, monterey:       "85ef5702b8f8fec1c73fd48083b7c72b14a02b86a69c3edb80e1af46dda11aae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "539c2f522ee963d56e355b13630dae0daca8ffe79edd1af1c68fe8048c3552a5"
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