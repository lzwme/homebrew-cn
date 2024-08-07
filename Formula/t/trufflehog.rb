class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.81.6.tar.gz"
  sha256 "57afaee30c7508af3bb408b8eec0dc6dfa0c08456d8082181fbefb71ce2f361e"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "439945b9350bea2c70a449d09b0af9fa9572545fa317c6f6713c0d44d0557814"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbf977280931960244636fdd58d715f21f49375a53f7e82ec962edaabb3b204b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eabf70fa46c8e33a6be0dd4a1a12ca93eb4d818d20887e35fbc9a9464878fa83"
    sha256 cellar: :any_skip_relocation, sonoma:         "691d5e63131f18bf9203b200593233aa74ccdff66282f6f1a2ac001ee5961185"
    sha256 cellar: :any_skip_relocation, ventura:        "a5d1cd42cbaa0d307d05efa302848c82eb6fe4d623e2d0cba03d8599e76fa049"
    sha256 cellar: :any_skip_relocation, monterey:       "faf765d00ff1cec809daac398d6efefba8ed193e22874bd4d386f9009f420cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ce20cd3ff2a7cc9b1a44bbd78a5407d534dffbbc398925ea753d70de14e57aa"
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