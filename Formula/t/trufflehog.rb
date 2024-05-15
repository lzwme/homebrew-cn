class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.76.0.tar.gz"
  sha256 "bc2c4800f0a48d3c22380b29b116cc693eb592233dc68dba0386994b8f784878"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f93296cb25b853fb2064490f6f9b6fb16250d7fbcc755eb20a77884d124410fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97edffcad106a9446cddc19baed48f4a2579d34983ee4da2345e3761248fa921"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1d3135b6aa631e50808c9e1901f2fce389eff78dac3e390d79e592b2240274b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2254409fd6163da0ab8c4bd88c7718f4fc74398a5dbdf3ad792a7c926ca6d4e"
    sha256 cellar: :any_skip_relocation, ventura:        "35b9a98cc10c2d755795275cfd59654b091809497de426f0ec831c315d921072"
    sha256 cellar: :any_skip_relocation, monterey:       "065c3fbb9451030bb4a7bb46134c7c6fa1aeed616d0691ec3bb92418ad3da5af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93c784513312e01958f3936b3cc65fa2571415ffe2abf02f88764822d45cafb7"
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