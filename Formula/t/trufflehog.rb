class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.89.0.tar.gz"
  sha256 "540900a5108a6dc4c6ab00f3bd5a168da33bb6f121ff7fc9e1771622812a185d"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "003828e50e4398ab3e1394625c4c244ded37c89fb2722726d86b38f7733e1040"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfcf426ed57709c15de889fbcc162837314228fccab7d0dbf87ff94d4b0b9f34"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a8ab7636b20629c4e8c68bff51fa8cbff5fcbc9a567b0903932f9582a48f704"
    sha256 cellar: :any_skip_relocation, sonoma:        "02d07375d709efe623049dc79e489f5c0a7d0b3ba5d742db7c244e2c14861572"
    sha256 cellar: :any_skip_relocation, ventura:       "b98d8aabed3803b4f798ca8c53b2f5b2ec0afb13f9cc3d361c0071802fac7dc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64e0b05f444b3bfa49038ea081ad91439a2f6e2e976b9d03adbd0c0e4f35167a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d31f1d24a9d61554d33a1ea106e17918450f14ee75ef107962a660072b0e29b7"
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