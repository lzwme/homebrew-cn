class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghproxy.com/https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-beta5.tar.gz"
  sha256 "b096edf031d2dd19fe6099763fbaed04ab9e2cba972b54efb3a3b386f321a2c1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e82a6e3c87c014d537fa24d77a22db8ed52ab2f1cb973d5d56f32f1d2d3d63c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d8d49262f6fad80d8a8bd4a793e99dba424f7e2d3852827ad774a6542211eeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5da855a2bffef0910d503afa3f6c61c402803ce0603d635c967ebbdd9f3e845e"
    sha256 cellar: :any_skip_relocation, sonoma:         "776c98f049af0cc060056cb3dd92351fd8e3492d7228d6d7685a699a4d61ddad"
    sha256 cellar: :any_skip_relocation, ventura:        "316fe724847ce5987c4acd2cb994aa281db905c63d5a41035c06990893df45ce"
    sha256 cellar: :any_skip_relocation, monterey:       "85449a90ec77d2d4216757befc88c05ff478881bf6c9a763a8c9cb075f7771d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a4709d96fc93ba6e183f9d8525d2828e744277fc910ef9182af4a23fba625f"
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