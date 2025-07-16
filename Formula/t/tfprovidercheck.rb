class Tfprovidercheck < Formula
  desc "CLI to prevent malicious Terraform Providers from being executed"
  homepage "https://github.com/suzuki-shunsuke/tfprovidercheck"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/tfprovidercheck/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "46a0db7c6cf1446d1422886468eead057e2347d9f0fdb59859e681c31b7051a4"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfprovidercheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5b941e01ba104b6451b0ad9356b90d1ef79f3a5fe1b7d6648aa9b3bd0cff6f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5b941e01ba104b6451b0ad9356b90d1ef79f3a5fe1b7d6648aa9b3bd0cff6f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5b941e01ba104b6451b0ad9356b90d1ef79f3a5fe1b7d6648aa9b3bd0cff6f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7984e72e396fdfb36cb46cc0a18c95edd79afe79493354f1a092bfb445d73b0"
    sha256 cellar: :any_skip_relocation, ventura:       "e7984e72e396fdfb36cb46cc0a18c95edd79afe79493354f1a092bfb445d73b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b28c40b41a92e5910b0f6ec3bafbea79517384a3d616cf8db9ec4746e354a5"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/tfprovidercheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfprovidercheck -version")

    (testpath/"test.tf").write <<~HCL
      terraform {
        required_version = ">= 1.0"

        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 5"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    HCL

    # Only google provider and azurerm provider are allowed
    (testpath/".tfprovidercheck.yaml").write <<~YAML
      providers:
        - name: registry.terraform.io/hashicorp/google
          version: ">= 4.0.0"
        - name: registry.terraform.io/hashicorp/azurerm
    YAML

    system "tofu", "init"
    json_output = shell_output("tofu version -json")
    output = pipe_output("#{bin}/tfprovidercheck 2>&1", json_output, 1)
    assert_match "Terraform Provider is disallowed", output
  end
end