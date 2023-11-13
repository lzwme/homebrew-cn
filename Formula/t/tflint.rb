class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://ghproxy.com/https://github.com/terraform-linters/tflint/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "556ddf20e24f687595eb55b9982276ec38974a75eb10f1fe6917e34d7cd725a8"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2de61acee493eb05718aee68fcf9e0bf06dc24899f33aaaf3ed840f2bba30ae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "804b110d5818da4b6c5128549403ebd21a589173f92098c0c39bf2dfa3bfb65b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7626874be2b13d322ba2093803bc32fe42dec43b5478ad3bff7a628e8e9207b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a804cfec00d6ef1f0091500f4b06b72c10250e7f13695a3121b46a7f9d675d5"
    sha256 cellar: :any_skip_relocation, ventura:        "ce18f4025a410c59e2c4b8ab1e3807d375ccf45d9bc070cf40e019733a364d0b"
    sha256 cellar: :any_skip_relocation, monterey:       "3817cc1d85cc581115d5f9dc54c6ce629a4e35d7f0292b3c8db85fc05b0515dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c18568e3cf66fedc8425202663ea693c31a92a01a26279bf25fcd6f79b435bb2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.tf").write <<~EOS
      terraform {
        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 4"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occurred), 3 (no errors but issues found)
    assert_empty shell_output("#{bin}/tflint --filter=test.tf")
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end