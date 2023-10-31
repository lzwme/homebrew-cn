class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.62.0.tar.gz"
  sha256 "8378e25eed5ca2eb1a8eb9a038cc50db2fafad91808ec4a84224887661d493f4"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "867ef0697c48f2c7ddcc1e94d2000458a608284d9f69c3bcde451a499b93d260"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6643a8ac975ce5e69e5a15d5a196ce2f9e821ac987fb644e07b918ae1bf26a4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7a7b4c3d336965204496ffc6f734b474c123dbd47c0221aebb80fbbd070c08a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2073a8085a489f094ebfa65e3d30938bfac20f9b266a9a9e0aa73d0666c66d01"
    sha256 cellar: :any_skip_relocation, ventura:        "7b084b2de4283cc11e7824c674bf3c394c723c3d0466f45ab4482dc0802a97a8"
    sha256 cellar: :any_skip_relocation, monterey:       "cd73108a3587477a678c8d29a81851fb72cf9b762012883e3314200f3b206eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b9a58110fdc13c3b87a53df97a4a1b7cbc2838e103556efaeffa033ddcd9d30"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end