class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://github.com/opentofu/opentofu"
  url "https://ghproxy.com/https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-alpha3.tar.gz"
  sha256 "726674ecede236fac2af0307c3afe74f1d2c5ae644f2195ca4e2ab2045364a77"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1ad2a324d832f8a66ec0f03884c1113cd1e768761df643ac918030a7a5cd843"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92043af15fbafd4e587773693313fd162f4dd496c9ba9dead3e29874323700c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91e99e75f9b50036205e4e3266da2d8c4cb3d12c8e5df575ed5f4511006f3b5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0d136f3a88f86cb86295c615fa13a1d815b12a84e978da64aa1f2f4b2054126"
    sha256 cellar: :any_skip_relocation, ventura:        "0d34b42a02aa7f850775d429eef602d101a73aaa7a2412098a5358b78c368f61"
    sha256 cellar: :any_skip_relocation, monterey:       "e4049e0d76936837945a8152c3c02ceca37c128263dea4174208389f8e9ea0e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07c15411f1c70bb929f5fd1b058b159a93ebf9834b6fd659b132fe0a99342734"
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