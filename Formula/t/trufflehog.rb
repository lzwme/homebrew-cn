class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.63.0.tar.gz"
  sha256 "841598a935d0835d2118461f25cab5fa1d3a216b8c2c31cd7707d8f36d54e109"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8456318671c9d4edc55f7eac7e7b31bf3dfaf568bf02eb09181c0a99d167e7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90e4cb3b03799c14ffee4697aaad442d3a8d16dae373c5ed54cba2f83e317a32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7b20519ee78d358501bfbdf89a70656d12eb273f4ed480fbcc8005056a58a06"
    sha256 cellar: :any_skip_relocation, sonoma:         "5be864e073ae5301e398adf8591d03129b1d270faf9d863f2700879f4127110b"
    sha256 cellar: :any_skip_relocation, ventura:        "f6791c44af169630bdf391d3fd72bdb348dbc34dfd3cb583432d4a7b8ce62da6"
    sha256 cellar: :any_skip_relocation, monterey:       "8925724c7d957f41060a8ae8868585e63b9899c3ee436ccc45adeb086eef08eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac41157138a5f8cbd846721bd8fd0c6393842a2a7770acd122c9fec0e800e1c5"
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