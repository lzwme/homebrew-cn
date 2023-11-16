class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghproxy.com/https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-alpha5.tar.gz"
  sha256 "76a378c56c4fbc4bc83663211625d4dafd0b6342b93a164eb8d8bec99b08dea3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5429296a79e0c924705287d2e6db1f537f57adaf06d9936a0cc80f6a1a725fc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4259aee1f20265ac56372b0160dd506f966a6df94d906d25872ed46c551b1cc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9086f2be8116eb65eebcb7e627b1cc8b232509d22f29b5eaecaa61ed3e6621cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "841125d488d24b494dc5443c7f37d1e6cc7893b2f8d4edc844d994881916e1ac"
    sha256 cellar: :any_skip_relocation, ventura:        "52305d5def74fb925731bc81bbe8d1103f426a22514670704cf8b8705760736e"
    sha256 cellar: :any_skip_relocation, monterey:       "5432921777329e3dd106d10093d13c2894a9b7b28d74a14ba01eafbce2fe88c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2da3a2add12194650c53d906a44e0c4636fa76c0de920384a2c8cfbfee1a1b"
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