class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghfast.top/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.92.2.tar.gz"
  sha256 "4419ae0cde8023205d3396fd94351b97d85019ac07fceabfe75dc4ee2f9c2b29"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6a9c5cb7c9bd5c032960c9da16792696bc48096b4bdb3084cbe9054bdd46b74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ffc6218f32de63d7a82aba731512dd8a4dea66d38c6fd78d9c7ebbf7490ced7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e7e543691d0a542190bf4cc7db655f471cb62ce628ea295039fa2130a228e36"
    sha256 cellar: :any_skip_relocation, sonoma:        "0786995b0eadadb7b8246479e4579026b55fb71c8989cb31bb12d6a998658f4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1966a2cb518e04da961756ecdf8287825f567e292b9bdde1e6f3f7831e91e0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75634a5973c00d5affe3b1ffb96eda0fdb1d901df1013ca9ea8c0cdebf0ecfe6"
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