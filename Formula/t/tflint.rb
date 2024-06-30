class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https:github.comterraform-linterstflint"
  url "https:github.comterraform-linterstflintarchiverefstagsv0.51.2.tar.gz"
  sha256 "3f85218f3ec9554faa37c7b9791486329804ba32bac1b20befbe1deed61b0bca"
  license "MPL-2.0"
  head "https:github.comterraform-linterstflint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fb5c7600e62207c1df0e719298ac7c4ec3c34f07297c31751ac442bdd3d74a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f887affe0904d4d54393a424435fc435445b83444a44dff95e32e165125658ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c35820085ade1a6d7643dc9b484668abe9254eb4bc485b4fbec581e12e5e1a1a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7a3abba09a81858b9ea8a65f48bdd19c46f443913ffc96c1a2692ae9f2b8eaa"
    sha256 cellar: :any_skip_relocation, ventura:        "890ec3c38ae6a697b36680233de5ca89015594b28c97b8c5657ded751f417830"
    sha256 cellar: :any_skip_relocation, monterey:       "90c6aab25ccaef7b6d886da93a2625f5d024f1fabdad7ed34775e559dfe9bab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda09873ea450a5878f335c95d52b9d93c5fdba9b0594690a553101f89a42faf"
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