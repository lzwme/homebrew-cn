class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.0.tar.gz"
  sha256 "8040dc349e9a169029c089c1cf8bd1a4e7909b420fe41308e62b9ec21560958c"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2f0d206e8add05cb91b4aa2205d0fe8814266b7226437b208a25d41a8e19bc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd8ff0c2ca09814e21c5928e5eee5d6998b228b8810199973734316661e8febb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e1175ccd133aa62131e2d5920c41f8fa6ff1fb7115f4af881e44aae6a331e97"
    sha256 cellar: :any_skip_relocation, sonoma:        "993f4bce776b973b4837205329c837df12d4d5709c6fddf184a82c3248bedfee"
    sha256 cellar: :any_skip_relocation, ventura:       "19ed3d5145f4c511622838f8103fb6af5bd7d62e85befc42a850bd338e8c085a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2af0c703cb9c92b8d2a32e89c1a930c82f782291e2897d0f6b750b99e5de5a55"
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