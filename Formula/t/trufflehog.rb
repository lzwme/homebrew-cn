class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.82.13.tar.gz"
  sha256 "19277f166879b0d5c37df283b9adf86acf42f15ee19ca59f279a2bd8328b6e99"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "973abe4e6a3b4d04dc1bfe470ccbc6c261696e2a1263f38e201e171cb78029d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9700b51fe1ba9781a4ef52ecdecbb6d958836bfc9f58346101173245f6d0c388"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ac84093b2ae2a2af7e64ffe35f81d93d0a3d3c00f507b75760a9b962d90b9f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b4ab2f78f0067730ce2e52bb39e59ba4adf15da050fd32f7cbc477234fca54a"
    sha256 cellar: :any_skip_relocation, ventura:       "b2290f170790efad11b5856efb80127306941959ca988f729a20cb98508a21fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "404a7962466e71fa133f4055120a5961ff4cfc1a42ca906e0892c327b748a298"
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