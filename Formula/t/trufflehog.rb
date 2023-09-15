class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.56.0.tar.gz"
  sha256 "5e655832b225e7bd067d919b7f881de97c0a7b3d00be87fc9fa340def97b569f"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d36fd3c2e11c5dc6aa52073fdcaeb8fa280d3b0106ec2474428665a613d179b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8a11040b96518fcd3d8a331273f50bf7bf657a6e472034f95feb6d7bb9ea700"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c9829f989c0eb599fc8966c28b4ab861af51a736d19c6c9da5e6e2b64610c8a"
    sha256 cellar: :any_skip_relocation, ventura:        "d7987ed3acba14a1c18abc63ce762a1c4b9ef2c24c79283993317c60b72ae8ac"
    sha256 cellar: :any_skip_relocation, monterey:       "20ce7ba2575bd839d6e5f561d8b0b994f09bc149a0ff677a0704a71956cea09a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b08341554b5a790378b8c64956ef4425ea3f2dc0097d5f3e0d7a36ccdd084194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a9fca207e8954ee22f35581573304ad0038a481e107bb5a03b1f8b86c609828"
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