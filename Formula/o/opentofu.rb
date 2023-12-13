class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghproxy.com/https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-beta4.tar.gz"
  sha256 "b14f151839d90d06f95ba4257be159857606daf522d99e9285ddb248f814393f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bd47e50fdc61a02313fc16669de84da0cfcbd0edf289c405220f5cd999b0283"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "524117e7da863246ecc0e0d44cb504a3f9d8f0ecefd97c1da66cf488b70cd9fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46535a4f36200e34c94af39470cd7c82df5f861bd1cd32454e4f223d4607111e"
    sha256 cellar: :any_skip_relocation, sonoma:         "db8770e26eca30e2e2ab37ce041b1fe52e304f65e1d846ada8413c58a34e4e4c"
    sha256 cellar: :any_skip_relocation, ventura:        "6803b20e1a262798caa92d424271c689505df3a4f3e5363d76862ad68ff1de60"
    sha256 cellar: :any_skip_relocation, monterey:       "67c47d93b4c6a6382568a8896f79125dccfb2d6e69edc18e16f364fd987a4c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "563a6cf63e98cf9fb13d73da0b15b196b0352fc932a1d2262d5649f57af4ef73"
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