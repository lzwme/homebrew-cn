class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://ghfast.top/https://github.com/snyk/policy-engine/archive/refs/tags/v1.1.7.tar.gz"
  sha256 "235f3de2da44973db56731449886eb361f23b0bccaa63f7624504045f0087828"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea22950f53cb7b0f04b4c65d0ad5dd9eb75137efe03ea1183c260e283c2276ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea22950f53cb7b0f04b4c65d0ad5dd9eb75137efe03ea1183c260e283c2276ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea22950f53cb7b0f04b4c65d0ad5dd9eb75137efe03ea1183c260e283c2276ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b3635503bcd453f10fdc3f63304f7de2af61ea12d079c1d7415387e68b72aff8"
    sha256 cellar: :any,                 x86_64_linux:      "da90d85bc07e09f7c4be07bdfa88cd97959f355535316362c5de21c29e3502a2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/snyk/policy-engine/pkg/version.Version=#{version}"
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