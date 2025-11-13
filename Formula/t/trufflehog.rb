class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.91.0.tar.gz"
  sha256 "7e272a16ddb868c9f50983bbaa5fe9b2a717d1c155de448d4823d3bbc0e5dc93"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c4abac35d4c7f1647f1cc95a819d7f4a18b0eeae0f52a48dad680a10561c34a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58f047bf744a4d397bbb9a74552bb99717f8edd9ba95e95b4dac1c8599e6afd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "642ab4584d0e6ffcd34090442943cf0039d2b6ea6a457b4e899dea1cf817e1da"
    sha256 cellar: :any_skip_relocation, sonoma:        "22de5d35be80713b1f2e25b008350bb8e638da3c915510d3769db297909f961a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5eeeb4cf7cab62d28e9e7aa72f8f0b2bb0107345d8f5dc336b68aeb308df929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d5186ff120a8a0c27db01bd15db1df30ac8d68b5aad0986db10a2bde9d42b0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end