class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.7.tar.gz"
  sha256 "ff63a1b3f6725adf803dac25b942da7d2d5ae462f421c30fd77febd81f605703"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ada05767188fcff31432a6f1a0aed2b4d2211b235dad155622aa8dba866aaaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f53864cca0f64067daf39b812982ba5c888650a86e2d790ad6f82bf1979aa4d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41913a11b06d5be741b669cc483997384785b68deedc3009967ebfdf1ec88bdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f10c6cfac75108c04a5e4813e1e4ddc3637aa4a29a37a8df29def0520702031"
    sha256 cellar: :any_skip_relocation, ventura:       "f7f497469e7297db930642b85357daed728adcb247bc999c7730291096e46fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "207612c7cf1a96e7408c7462266d9a56086aba92918faa63fd8865e077158ddc"
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