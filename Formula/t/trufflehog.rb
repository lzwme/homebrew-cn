class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.63.1.tar.gz"
  sha256 "b0e3176a50e6d68574cf4204f88c11ffb2ee96b9d1e8869fcb0d7af67dfc806b"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65515357bc6603cd77300aa4d4be05a7e4646198a8d5bd71a67595767489ccba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98bcde6127b1ee361183e29aacfb843aca776f6de4674c0e1b4170ecf2bc7ec2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee4f0199ffecd5e3f7164da1d01b002afbc46404364d122ea05837c01d663330"
    sha256 cellar: :any_skip_relocation, sonoma:         "edcb5d4fe046ef102fe054d3938b8239e61efdc67561c1d9d6a4102526b3e309"
    sha256 cellar: :any_skip_relocation, ventura:        "fc4692786d4a0cb7655401bfe3962bd2d034bcbc99f1ae7adfd142147e4faa82"
    sha256 cellar: :any_skip_relocation, monterey:       "039bc17ea38eed761f5a9d88d851da23bb0a280b1c10d309c45603bc286cd64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "badb6f846f7b5c7e260f0ca7a8e4548d7841552b1567227b835b3f04e43b24c2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end