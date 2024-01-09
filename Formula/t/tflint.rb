class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https:github.comterraform-linterstflint"
  url "https:github.comterraform-linterstflintarchiverefstagsv0.50.1.tar.gz"
  sha256 "ef019d3602cb6eae33443c619230b28eb47368126337f6d496a2060b7ab3f950"
  license "MPL-2.0"
  head "https:github.comterraform-linterstflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9a206b7df1e658e26f6486f0dcfdb8018f3797bedf8a9f330e4dad349c2bfa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1c59c61106e9c105a67cc58ce60884339d440dea1fefb7b13be12d695c7560d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a61e5a8717c3b7ad85facd54e7b8626b24a25036aec960518f5dbe582d81b80a"
    sha256 cellar: :any_skip_relocation, sonoma:         "0240c1f62abb27b8e9be48c414dfb922d3c46bc67540655c139ba62b9e55cb9f"
    sha256 cellar: :any_skip_relocation, ventura:        "6afb6c4d396f8757f13f0c05517a2eeee631a27e6436e4c6c9af40ffc35d691a"
    sha256 cellar: :any_skip_relocation, monterey:       "e151b550d8f3899d010289d8bfa1b9699ecd3e8d5aabfcb83933aad537fb38b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89ffb6b01fcd8d72a5c9cce0c652a81599aead4e2416385a214178e01b972c99"
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