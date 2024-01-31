class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.66.2.tar.gz"
  sha256 "aab4909a32ba2df14924dccd1ff35d6f29c6314b559f140b0053dbb0811f3d17"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f536db3d777bf7ec0a9e664f30b607a8809cf3207d44a4ba2f31f84486c5dd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7efd18e0c8dc20f4e7d2999f8829cbd0eb43c671e8161f95c0237f6b3e5f065f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b260d326f75ef682b0cbf859136f95d6a358f937534a2bdd665f734b64bff5a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "caecc8dbba51b127415c677db40361bfc402a358f74a0025fd3cac391710ee87"
    sha256 cellar: :any_skip_relocation, ventura:        "3302b84af895b247f653b52a6dba38a58a362f2c9f6ae853bec091e2dfa043d3"
    sha256 cellar: :any_skip_relocation, monterey:       "86c7585a76958a214b5cde80eb7fca7fbf2c6d105603c881817d82feecb27c0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "177ebd1e7b24442a6fc6e5f0f460512f5f83729e3ffc81149819b33676838622"
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