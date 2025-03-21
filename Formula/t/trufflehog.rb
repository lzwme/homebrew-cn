class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.18.tar.gz"
  sha256 "39e8431891187386bfc77d1e15feb912110c3dfe1106e66a6c7ad62774621d95"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4be1757c01ac44dfa2b8c04767f5ed5798c589f264faed4e0d06b53937abd2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d0c8598384b80c43fb6add55e736a20294782c7b64f3691cf7698635bfbd5fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7b1bd694d13d32f66c4af8c0e69ef107b2ddc589666c00103ce0735ce334711"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec19f2e6ca6ef4e5c59e266c3eb6806d063546f4d0197f9bce170cfdcbed7884"
    sha256 cellar: :any_skip_relocation, ventura:       "1102baccbdae84cca2efd5f193ecf8d567f9d36db0554d13665674b7997f00fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e958030ab68b564844bc9b4f6dd4f05850fbe1a73e23a9eb9709518ba4911d78"
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