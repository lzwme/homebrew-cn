class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.81.7.tar.gz"
  sha256 "228b946c8023144735f5c173c5db10352366ef949bfa4d96e1e5feaca5f79e42"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "153a56119077f5637871ad8b08eaf44d8155465da275e521fe24b6cc00ffac50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fecfd7b49f90ca8cac7ecbbb14f84b54dc41ca1fd67d9319b30cdadb6e93b9ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62755ce1ab18995e05da0da73afefa640d49b1f34f5bdcf39e20a2efc1b1a8dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8e625ab68b47259cae0d94c86bfb5ec6a9d0c0e658ddd5d0123a304ff5507a3"
    sha256 cellar: :any_skip_relocation, ventura:        "f90a54a89efa72cb9866fd754f71ca7a123f7a79fb0e3884171bd3b2360078c5"
    sha256 cellar: :any_skip_relocation, monterey:       "5a72763a1027686d63aed13cef0dd522616dbaf664817a8b80da0c1192ad7103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dca1460417c93923a0ae6a5cd439468741d385245acfc05e7ec33d739d4625d"
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