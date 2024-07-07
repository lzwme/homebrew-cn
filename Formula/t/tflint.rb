class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https:github.comterraform-linterstflint"
  url "https:github.comterraform-linterstflintarchiverefstagsv0.52.0.tar.gz"
  sha256 "18ccb225df4616b3c91681d5b2ace423e4522c4cc71c68e6d1df665d6f0a7cdd"
  license "MPL-2.0"
  head "https:github.comterraform-linterstflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d546f1cbdb71f2cd5937ee4a846d097a331684b220e5788600c7762d940b31e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8a5e0096b2c722af52fce90c66ed2fbc7db641ccb6c03a3caa3f715b606827e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15edcc02aa6f392352c0c78768501a25ca992aeb8e2f24a2dc6441e4266ebb3f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eb4cbaedceec907e7532c8f11ee20cbcf0677e820b2a9573d41deb3671a4ecc"
    sha256 cellar: :any_skip_relocation, ventura:        "c7541c973d829ceffa5f31d56daad3a3dd8f31d2ac6b2386f0a7d0825b93ae85"
    sha256 cellar: :any_skip_relocation, monterey:       "ef9f96115630bf5c4f34a50e5adc65a6222c72ad24bcbd2a98d7a9af79993038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a3f36f7b4391276e4d771ef0a20f8656447bf3cb1bb2d9ca89c4c04a05d6d8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"test.tf").write <<~EOS
      terraform {
        required_version = ">= 1.0"

        required_providers {
          aws = {
            source = "hashicorpaws"
            version = "~> 4"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occurred), 3 (no errors but issues found)
    assert_empty shell_output("#{bin}tflint --filter=test.tf")
    assert_match version.to_s, shell_output("#{bin}tflint --version")
  end
end