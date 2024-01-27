class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.65.0.tar.gz"
  sha256 "1c52698e6840eeba08e87e4bf81436fcf2b9f60f36a4d1dc5b48ec597abac34f"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "213f0040629e9465ec552fca0ec2ea5594059836cf1a354c685d0c295175519d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44a6100f2bb8aaa266ddc4be2b1d508b1b2047edadcb4cdb8f98465f4993b1be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1251f6a1848a0fa2c1acbed1752d806113ba1a3bfb4582594509c39ceaeaf1d"
    sha256 cellar: :any_skip_relocation, sonoma:         "694f04cc225a087dbeedb0571ce33a49688b30206664ac37ed262227c862ad61"
    sha256 cellar: :any_skip_relocation, ventura:        "85b6b065385dba2129dbc76688d0a1d4312b149eaec9f742bf4828347bd4c75a"
    sha256 cellar: :any_skip_relocation, monterey:       "df4143d2eded7edb69638bf96b5b2a1e509d1049ea2730262d2ae052c9833502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "229337c4eb5306747a2d324b6807ec891f2c6a086db997ec14db0c94ac7761d0"
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