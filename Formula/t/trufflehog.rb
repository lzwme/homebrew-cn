class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.67.2.tar.gz"
  sha256 "484986a2e1858b11df882919b07f4d2cb04252cb1659d2cbe807df5b01103d97"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b645c8dc62596d71082aaae718e5d84ad6c30f6872ade5d54fffe6f749fb8f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cac23e3aa201b6526afed7aa21659990388197caa993ecde84bc864262434bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8bf0e7bb666a33eac67e26979e9ed20c5c2ffe70518f8a981b28edc6de7b4a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d7412bc3a21112d89bb1150e141ef104c8562197e8acac43e6d92ddcd3e146d"
    sha256 cellar: :any_skip_relocation, ventura:        "583b02e35a1ea8008dd78424c11c8799653c6bd263fd0dce53d6d8f870e6d6e2"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab7c8c22fc2edca397578017c9953c274d3e18ea6ee6717705b2663da77d44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "528d64c4c1e2b46e63efbe38125d7cb05ed75bbb4dd1c115d30c6d18548882b4"
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