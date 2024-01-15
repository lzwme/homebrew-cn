class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.63.9.tar.gz"
  sha256 "a013c27ebf97cd4e9448ee844906bf47ba07c0e1654bac8251e80ccac219bf53"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c5faa6b1d1e8306440898fbea36421399d37137e7f1ac21518a41127d9d5740"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a086cc3ef72d3ec6cf711f5cdbd1ce05acceedf2da3a9818973430f9323a9799"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "317249dbb4d0ccb05e6e60c053d0792b55083939d1e23e1dceb969d33dd4b52b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2891c3664e55107993e11aef3230d4ec167c39ecef04a47623b205a75dee8d7b"
    sha256 cellar: :any_skip_relocation, ventura:        "b57f0ded8ea5056eb0039ffcbe3bfb86795e9c55655add34c67e41dce8732110"
    sha256 cellar: :any_skip_relocation, monterey:       "9b1728f471638b5c12efa8693d029e28a7ed1354fa791ec521188de14d2bedbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b403195caa71190ace0f6ca2032b32ada8867a171e72131a552b731c712dfc69"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtrufflesecuritytrufflehogv3pkgversion.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https:github.comtrufflesecuritytest_keys"
    output = shell_output("#{bin}trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}trufflehog --version 2>&1")
  end
end