class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghfast.top/https://github.com/opentofu/opentofu/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "ff95091fef8d413938025f7605311cf9b1ef2d1a1a19ee575dafa4ecf5774e0c"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5437ba3fb1454441ca6d80f657412507ffaf9589893b227c7ccb8f2d69ec58f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "374788790965d39ffde67edc0ddaa1af3642182a7aa09a1475363a9b246ce832"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a4f5d30d2ec0c105c3ac4f92c7561ad654e95b48dc003fd05adb0dadac7e232"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6807fc30e8792274db7aad9115400290277264623aafce43626acf23d9985c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d4cd18f380962f9a8d989b3abc6f46332f218e5fb2db5e01388d379687344a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bce5c10607504c98e9bcd52b95613d86bf717274daa34ed8977b413a62b54d1c"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags:), "./cmd/tofu"
  end

  test do
    (testpath/"minimal.tf").write <<~HCL
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

    system bin/"tofu", "init"
    system bin/"tofu", "graph"
  end
end