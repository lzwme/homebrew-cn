class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.7.0.tar.gz"
  sha256 "04f43bc496adc3dfe5ca39121355ed5c12b5b1f3b2cceedf1aae3382bceecefc"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c67dff3b09170e249173d9b445647f8fc2b29b20b5c8a2eef184b92881e4bc48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cacd16d08e3a4da121f6fa1a77ea31952f7b1d403aa243adbdf0f1d35e4e2f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ad0f7bd53350334b4017e7304f4d5babc1b24f68e82d5f2897826b611985943"
    sha256 cellar: :any_skip_relocation, sonoma:         "2154802b34a13d5825823d414914abff97b0e8746d5a6ba03b01e0a00b7aa5b9"
    sha256 cellar: :any_skip_relocation, ventura:        "be67c3c47bdbcd92ebf7fbdd88a643084989e67396db5b21cff9ed350cb33805"
    sha256 cellar: :any_skip_relocation, monterey:       "3b8bbe316fb5db08ad430a0861a136c96a996a3ab402e64b42479700cc699e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9de3a269a6cdc0498cf18bf68310b4c85d6542fe71c84dee107116ebe2752b7c"
  end

  depends_on "go" => :build

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
    system "#{bin}tofu", "init"
    system "#{bin}tofu", "graph"
  end
end