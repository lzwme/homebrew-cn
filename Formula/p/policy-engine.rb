class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https:github.comsnykpolicy-engine"
  url "https:github.comsnykpolicy-enginearchiverefstagsv0.34.0.tar.gz"
  sha256 "cc61ac06f363a67619054fe50c23e3f426c7cef3126d5fe797263f75643147ba"
  license "Apache-2.0"
  head "https:github.comsnykpolicy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "495d5173ad8a462721d65e891bf831a2d3474d9a237e45ff9331853710adbf98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afafc897a5e8508325afba6f191da1412d0246ea7acb4efb71dae42330f37117"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e23695932846e1506ca7cd7294db6b21215330325e40da46941f8c730da0d2f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7543165e28d12e5ff5af0535de81fec7d4422cd4388452303bfb68197994e4af"
    sha256 cellar: :any_skip_relocation, ventura:       "d3d1f63bde5d9f93eb973d6c018d32c3868bb31226edc6efbe24d915c0ab2305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3587a14bb6366e5658872e4a0148c6f3b6a1b10915a42f4b96f747f8234d9eb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comsnykpolicy-enginepkgversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"policy-engine", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}policy-engine version")

    (testpath"infratest.tf").write <<~HCL
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

    assert_match "\"rule_results\": []", shell_output(bin"policy-engine run infra")
  end
end