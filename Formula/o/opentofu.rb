class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghproxy.com/https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-beta1.tar.gz"
  sha256 "8befccf2743042ec3d36a10414ce6a287bd678534513b9860d4eae0942955d74"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88247b968ea75c76b0193d136a0b7d2ce2b6659fff49798570dc0df3e2e12057"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6a0500d4803473cba7b736d3d1f6f28b0e53e3874aa784badcba8d5206bb79e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1025d0e6100085f418f51d3caa8580923f3778ed7e848488922dc672fc1ef1a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "47c0911c28f9b0fb9b4543027eb648ec9e68c50795bfd66a3ab589c8ed2d7ce3"
    sha256 cellar: :any_skip_relocation, ventura:        "b3baaa5b047214855c4c12cf4636342438c39cf540756270fc8fed408db18016"
    sha256 cellar: :any_skip_relocation, monterey:       "e6aef2783ae51b574784121464a4f3800cea4fd2903b7d280acbca2bb4945e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf9c8f343b654b17e39b66344006c24abdf2ad5213bcaaff7c32471327a9a2b"
  end

  depends_on "go" => :build

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags: "-s -w"), "./cmd/tofu"
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