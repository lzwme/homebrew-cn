class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https:github.comterraform-linterstflint"
  url "https:github.comterraform-linterstflintarchiverefstagsv0.54.0.tar.gz"
  sha256 "5978b9a95bebcd198c37be7efcb9ae60ec9e49468dbbfba6ffade496921da25d"
  license "MPL-2.0"
  head "https:github.comterraform-linterstflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84a20a964b92a2814fa4f9b33b1b5323c82e8d3af280e7f86a5f714da0177f4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84a20a964b92a2814fa4f9b33b1b5323c82e8d3af280e7f86a5f714da0177f4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84a20a964b92a2814fa4f9b33b1b5323c82e8d3af280e7f86a5f714da0177f4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "89021b8493375b8b282c81319c5dbb91432c77d317a069f7ae32cbd7315f56f6"
    sha256 cellar: :any_skip_relocation, ventura:       "89021b8493375b8b282c81319c5dbb91432c77d317a069f7ae32cbd7315f56f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea6105e001955a34e8fe1c0326830970abb4d98e28a51eca3a13605c6966b90c"
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