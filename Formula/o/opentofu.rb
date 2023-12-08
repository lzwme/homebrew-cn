class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghproxy.com/https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-beta2.tar.gz"
  sha256 "d533354f9bdef81acd4620bc6662d6810f4bbe2b32936b6c32acd35d59f6307c"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70487bcd11192e39cfd7de778ce033a65bfb3206e6df4170c8965bd799015d8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e673957e514a32c2463df200ba921b7de0431d988ca7460e8714ee55e3ec3148"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a216bb76c92ee8f47ba0a96bba5effc8f43275c6fb37973a974aea693e22570"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff05eec7d8bfaf6951507a77fc91a6ba4a11263090249ecf03b6f4e384a68029"
    sha256 cellar: :any_skip_relocation, ventura:        "b2fab9d12c3a4fa3a0e9985e473fec07356eba8aaa2536021d623fe855e0e02d"
    sha256 cellar: :any_skip_relocation, monterey:       "43a210afa7398e52abb6822b81d427c402d480ff21a89c28a5b3c146e855ba68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67615b3529fd4e30a0eb9418e6f976077fddcd521395c23a3089f3439267347f"
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