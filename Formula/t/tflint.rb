class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https:github.comterraform-linterstflint"
  url "https:github.comterraform-linterstflintarchiverefstagsv0.50.2.tar.gz"
  sha256 "dffc6ec7e212e48c9a778e1f3255ce133d20b66bf30295aa9cbfcc1095ee7daf"
  license "MPL-2.0"
  head "https:github.comterraform-linterstflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76d14b5bf9a378fe7f037aa2955f1e412e0ce7271a3a5ac12f121a6160193ef3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f96f35299b86535bd77ab7c9609449194ab3c48c0cb00d96f4b3d2252ac65bc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e679a10646b2951f1c1723879bfc2fdd9c72d1040aaeb2bdec9dfbf286dc966f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8dc437789e1fcc5c270c963434c4449621ffbfaf98a5762f897645bb4432d0b"
    sha256 cellar: :any_skip_relocation, ventura:        "acce8dbcba87446e791dc72a853d6bea545fb0753d3b4f90096e45f2be3c158a"
    sha256 cellar: :any_skip_relocation, monterey:       "59950d33166213ceafffed93ad90f2d33d5d52b2369e2188abec35d6c84b22b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "732939a231d2f46f55c61fbe4425f1a0acc1074e91de34efbbf358db9834a1c6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"test.tf").write <<~EOS
      terraform {
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