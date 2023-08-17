class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.49.0.tar.gz"
  sha256 "cfbfc279c5d84fa5b2af5c70905c0cdcc71d2a6f21286abc3593e705d778024e"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c565dc014d1978726305c58e09eedbff42c2b876cdb745b7701fffcd6078fb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d4f4633f565ac007e3c9ad0b50c4f63952d31ea9ee3203c70bb412f703197d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0bcd104b989445612687d182a6c6402148b0fb5757967c99d689f7d8bc0fca56"
    sha256 cellar: :any_skip_relocation, ventura:        "03c60cd2da2710d06ea733f27951913310ed12306b7954981c72ca95fd3f2514"
    sha256 cellar: :any_skip_relocation, monterey:       "86bf7fa3dcf7b845c31ff63840cb86c3122e7e3bf2d992769fcf602ef5382b66"
    sha256 cellar: :any_skip_relocation, big_sur:        "839333a4a2511fad059d52bd388a5be3f3dc43c4c500fc8200fe2153b3aa05f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "523bcc7762366f2dd3f495327add4ef897a798c887023f01db82ba7b1c5bd69a"
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