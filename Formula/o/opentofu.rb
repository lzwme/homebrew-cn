class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://ghproxy.com/https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-alpha4.tar.gz"
  sha256 "b3faa8e151b1051feb1fb8e300b3371ae30dc60a24b506db8b4a35326d6c4ca6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "326b6db5ca6e0d99a69ed3608f8cb39fd3ed2adf661c50424a9a4efb778a5119"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "085d5db81ad0d66dee91a108d3b180790f8cfe65c45c6cf9d4ae3c85f0d43079"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a69e715e264cc42906770068dc8f77f108b7764d7ee559464e3660ea1ff692c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5094f18c53c7055c6e78cce7652cdf2ae7f2e1aca7b15fe4d84b251766795720"
    sha256 cellar: :any_skip_relocation, ventura:        "fcbd3f862ca8a0dec2595b3627518b88bd7ebf8d7cbed831271b33d423d8cb70"
    sha256 cellar: :any_skip_relocation, monterey:       "dbf371eb6c7de1c79df71872222283fba152fc468c1a9db28eef9f0a49948c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b4a295746dea14b2a9c15501746dd824038b88eb5a93a17d38d4c196703604f"
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