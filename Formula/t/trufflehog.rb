class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.29.tar.gz"
  sha256 "ffe9be634161bd72582f29f67357b608c290060f7f00a717fe5d5f2508758864"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0abf4926fa7ab1a656e7bdcf62d3a290c274fd75d7c5e9f6b6597dbfbad9417d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "552d4265b5719f067d9f392ab72220de9155fda24f92ed008e19c424b6432594"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ae9fbf41ef112f6521365356690f5a2a71d3c6d1c6d400a3016b2639fdbcd9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc85f232374c6f7800d1ad1ca5855c753162829efa0978df043b14b0ac68b224"
    sha256 cellar: :any_skip_relocation, ventura:       "a532d62c12462a7833b42c571e7028d55b7a2ecdc22e5d1072816deceef2b2d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa11bd5a30f3a40d4e5bc40059b440c97151c74b30b36a244ad2249148627682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe46f53c30fc8ac379f541430d2715434bfd49080dbf8a2d9475ad59c95a6d50"
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