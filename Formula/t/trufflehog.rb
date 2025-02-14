class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.8.tar.gz"
  sha256 "7f40ba6989850a288580ac7c11966a4b1e6bc2083d9ba88ad85dbe253e48373e"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac2f13032aeaba0ebf63fffbf6ffe936da4fa71664a90d1278357b9388a7a829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "844256cf46574c5ea122e7b3f73795c526e3b5546a95c062f513bdc12f113054"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c5b0b7dfdc7b03f9a80b295f5266c12dd83fdf4678126bbb10ff6159b1db38f"
    sha256 cellar: :any_skip_relocation, sonoma:        "55150f269e774044d4d9604414818139e3396e1c73449b24bb427eba244487c8"
    sha256 cellar: :any_skip_relocation, ventura:       "c82e5826fc509b5fe8d0299b3da43e24350755fe9a47538a214c8b72862dbb30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62d05493dded1b89d816606e41072aa9a750cab82b6d5afcddc2e523010bb45e"
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