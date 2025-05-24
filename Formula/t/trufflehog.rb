class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.34.tar.gz"
  sha256 "54b981c782157e59020cb8a2203b11c3fbb7c5668f10ffeee474b68ca7060836"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eca33eeddca5dfcc9d5063b3b10a3f9bf8bb2704c14de5daa12c135b43174ee8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0425b9eea86d2ed04c2c9dd86079386fce1287327114ffde3d4a0a622c847d7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "935683c54a7f6cf2e8e2c44fbd70acc94bed7a6c250d68efd322b85de8fd3ff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "df8bdbe56395a17e477be20c8522aafa7713679bf8513bdf362e61411aa35b09"
    sha256 cellar: :any_skip_relocation, ventura:       "7590d6eda2e7969d45d8d72317b91681b5aa5b1b80733c919d9e4a8e28438c59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "692df3de3c3c42e4f67e0b1a00c500bd6ff198e9c62d669c4bd5f3c5448b7fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02a41ac24d97ef7eb769679148b9d2306720a0cb657fe81de2e2ab58cb6ee996"
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