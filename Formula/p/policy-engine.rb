class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://ghfast.top/https://github.com/snyk/policy-engine/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "847f5d886afe0428602b167cb29922c3be81819151fbbbc154d676e0b33b3714"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53cf77257c7ce7c4ad96e13c622757dc1c5383bd1cf09d702185dcd4d6127a8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53cf77257c7ce7c4ad96e13c622757dc1c5383bd1cf09d702185dcd4d6127a8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53cf77257c7ce7c4ad96e13c622757dc1c5383bd1cf09d702185dcd4d6127a8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a82bdbb1025b62ff5fd2316c791bedbe48c11f8936692c0a49112825b89a9d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51f7bdaec52eb6607a60f336c4848227176463b267f5021e1199fea7789ee53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "318212b9ba0060a0b821f848528131e3bf93591ed08e30e1a3f918f9878c7f81"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/snyk/policy-engine/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"policy-engine", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/policy-engine version")

    (testpath/"infra/test.tf").write <<~HCL
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    HCL

    assert_match "\"rule_results\": []", shell_output("#{bin}/policy-engine run infra")
  end
end