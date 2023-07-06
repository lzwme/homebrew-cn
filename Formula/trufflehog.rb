class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.43.0.tar.gz"
  sha256 "51060f261ed043bb12afe43a4e32c4456ab42c06ebfeefd4a38558a4c0e57dee"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/driftwood.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "900dbb977e340595ccadc603242dd078929e0366b3d3dd92f0a7a452192a587b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e29a34812aac18e8725bc92e9b4f40a7e3efcd7415ec8d0c9d25c7166979923b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bcd13b1803438d339586d56feb52a00caa8b12e46675a9320f663aabfe85abf2"
    sha256 cellar: :any_skip_relocation, ventura:        "e0b19340973224505035ed8c21feffb37f73e464975fe01270a7757c425c68cc"
    sha256 cellar: :any_skip_relocation, monterey:       "cd1cdf1bf01e83dfdd2fb8536e10e7587581a453990e04c099d71452d4c09a41"
    sha256 cellar: :any_skip_relocation, big_sur:        "d910e05c43e8e98e13a7f52933c90e5ef22025672169c9850fb61645201cb93c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e3559fdb081bb453d4be55473047f73223d0d6dd42f2e04b2356d04571ce47f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    assert_match "loaded decoders	{\"count\": 3}", output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end