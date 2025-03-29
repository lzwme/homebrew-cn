class Tfprovidercheck < Formula
  desc "CLI to prevent malicious Terraform Providers from being executed"
  homepage "https:github.comsuzuki-shunsuketfprovidercheck"
  url "https:github.comsuzuki-shunsuketfprovidercheckarchiverefstagsv1.0.3.tar.gz"
  sha256 "f2957ec6eb9cdd8abd8165bf6c3b048e14f44f5b9575d11624144a7c3e97ffd5"
  license "MIT"
  head "https:github.comsuzuki-shunsuketfprovidercheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1831bf2caa62d1f712fcbe93425e2308c5d2ececfdd0f06ca2286b2a52614bb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1831bf2caa62d1f712fcbe93425e2308c5d2ececfdd0f06ca2286b2a52614bb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1831bf2caa62d1f712fcbe93425e2308c5d2ececfdd0f06ca2286b2a52614bb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "413f9a5dbfe170c3a1dffeca89fa6e8854eaef4b02ecb163285a588f163854a8"
    sha256 cellar: :any_skip_relocation, ventura:       "413f9a5dbfe170c3a1dffeca89fa6e8854eaef4b02ecb163285a588f163854a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a94ceabeac6a06f831676302df40e130b4a80972531e8541dc80f940551e6041"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdtfprovidercheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tfprovidercheck -version")

    (testpath"test.tf").write <<~HCL
      terraform {
        required_version = ">= 1.0"

        required_providers {
          aws = {
            source = "hashicorpaws"
            version = "~> 5"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    HCL

    # Only google provider and azurerm provider are allowed
    (testpath".tfprovidercheck.yaml").write <<~YAML
      providers:
        - name: registry.terraform.iohashicorpgoogle
          version: ">= 4.0.0"
        - name: registry.terraform.iohashicorpazurerm
    YAML

    system "tofu", "init"
    json_output = shell_output("tofu version -json")
    output = pipe_output("#{bin}tfprovidercheck 2>&1", json_output, 1)
    assert_match "Terraform Provider is disallowed", output
  end
end