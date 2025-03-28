class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.19.tar.gz"
  sha256 "d1ca470a8df612e9b504e850a51622164f544bd99a8c8766beaf4f4abbdfa2b5"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "876579bfecd300e146e6f5e7e8eba69b4b9ebcbede7889a594bf01437130fca3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e19b4293d4d85fb4b87082e52ac88d330ffb3978404d208e2eb32aaa170c39e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f77673af8efbf3c9e1f78d06f74accbe724016aa0bcb4836ba196795714c56b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6c28700017212824a2cf6a1ea9e292ce2d80198a1875d2fee61be65433bf507"
    sha256 cellar: :any_skip_relocation, ventura:       "0bfcd1e5769e4d6adc5ef4e41da36d1244dd74ed79acfb674b8de76bf1dcd0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52563b06673a750a8e5aa1a166509653f688941c837c4e4face95320730b674f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end