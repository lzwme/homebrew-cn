class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.93.4.tar.gz"
  sha256 "07568633d361545284316f6f8a3fed96424ccf3b8aca4a61a1589223dbe19e13"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65f0dbff0bfb6ece75b4f12afd09f60cd2acad93a944ff488eb1e5fa0f783e4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a704ecb9d16068bc1359bade65772f50d90a8bf1ae53c83c7a71f7e1bc9b4154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a558e68853e23052b5b18ac50b00e91e34bc47d30e03404c14ec1437a2a6e554"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1479832647030ff3904db06df5aa3db866c17ef3111d5381650d859190f6046"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d40af6f76a1fb22242d1c806d6ff7674d3f9a6d7f918e0eaa6522415e32386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd71ec63af194287f263e1b38dd94f1bf6c67f9e8b9bc8de6a7c2172aceac5b8"
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