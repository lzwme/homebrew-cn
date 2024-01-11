class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https:opentofu.org"
  url "https:github.comopentofuopentofuarchiverefstagsv1.6.0.tar.gz"
  sha256 "0975d14a0d14fa7cc99d1e6d823580834dacc99a26f2ed145e4cb2145ff73dc9"
  license "MPL-2.0"
  head "https:github.comopentofuopentofu.git", branch: "main"

  # This uses a loose regex, so it will match unstable versions for now. Once a
  # stable version becomes available, we should update or remove this to ensure
  # we only match stable versions going forward.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+.*)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7a63de38a2cc1cf705a3f271a6d79821dda7be01fb56e028af5acc27486349f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c33aed08170278477ca5eafb91252e099e9eaa47d1af02f16436354f1c4e806e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40df1f012e1303f4fc6c2f2733e1ff6a16c231f456aecc8ea4870282df3a5bcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e44ffba904843963f63a1fd4c293427601748bc9a18ea6247e049024087134d"
    sha256 cellar: :any_skip_relocation, ventura:        "76a54e0996112d9ee784a6b20ea93923b6f5018173baaf8af6de2a28348322ef"
    sha256 cellar: :any_skip_relocation, monterey:       "24ecb26149b8b1d75e6f56f3f5bcb2abb4ede882ca5c8bd0e0b54741adb7369e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8c32b966c78cb27a15e3e68479db99a9437db13f55873613857730bef3bc143"
  end

  depends_on "go" => :build

  # Needs libraries at runtime:
  # usrlibx86_64-linux-gnulibstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    ldflags = "-s -w -X github.comopentofuopentofuversion.dev=no"
    system "go", "build", *std_go_args(output: bin"tofu", ldflags: ldflags), ".cmdtofu"
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