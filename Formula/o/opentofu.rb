class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghproxy.com/https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-beta3.tar.gz"
  sha256 "93ab2d424a99073548104cc72ecf4f7cca2c73578da79aed9452a78b30e59bf1"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  # This uses a loose regex, so it will match unstable versions for now. Once a
  # stable version becomes available, we should update or remove this to ensure
  # we only match stable versions going forward.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+.*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "198e22e5432b62b5941f0f5747fd49ecf8949173ed210349a1bb1f673de08a10"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c93a629ef3566c14ac9329f2392de8f2aae97d49b8bb5e2bc1912f8912e6a8e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "090c33a62ce4f28a836ca57c4de162b0eef6cb03c1b67fdb7d3a91b33e9f7975"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d108701e0b714c1161476af9e8fd37e5cd81322aa12441278307e2e37c8770e"
    sha256 cellar: :any_skip_relocation, ventura:        "b6597066c90f873c1993b587245d36277fa593752f779ef97b1f4b6fb0bf3103"
    sha256 cellar: :any_skip_relocation, monterey:       "08d4c9706d39d739dc3438c59fa37cfde90f093b58239abc7e36d2485615cdc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96946314a9bd428f360bc6a89da3852e5f7878637676d61b447a796826e6974"
  end

  depends_on "go" => :build

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    ldflags = "-s -w -X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags: ldflags), "./cmd/tofu"
  end

  test do
    minimal = testpath/"minimal.tf"
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
    system "#{bin}/tofu", "init"
    system "#{bin}/tofu", "graph"
  end
end