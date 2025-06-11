class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.89.1.tar.gz"
  sha256 "a34574f589cf5d9ac33f722a35ded5bf9c094356503ab8a1d9c7949841951cfe"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b07c7958bcccd939d4d546af45f933979bf4a5c400c9e38cbb33e5c645d39f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3678045535db09aae90a7352b5a987dc1e079c9727b6a0acbb31bbee01657fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa75a0ccce0f6416f2ec17b1dd17788c2492bbef574aeb083d72c7a09abd2a53"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e91f54524c0e8d966ed514f69abd6b5cceee6b819315b1e5f15c1cb5cb92468"
    sha256 cellar: :any_skip_relocation, ventura:       "0097e139daca5a050512530e85ce24eb648aa6e9d4de67b81bb1221b787d3a12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6a27e22abab84ded835ba797282dafd28cad662aaa53d24bdf630400630a8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8330bbbf803f9aeb02de39555d86636d407d6244052aa496c18cec47a18c978c"
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