class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.83.2.tar.gz"
  sha256 "f825f0801ef2f6d29331bab20496b9b370c08f5bd1575e1799986b392f100a01"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "371f97b643c8f29669bec14b0ea2ab57bec9fbe0b65072eb850b370c12014cae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b681ecb36b6902120cf43eae059b45186b354a66584992c9af965667f4c2a18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f532b778f743bf9404f6c672a665e415d77dbe6b5aa76be02d4ad0f817fc2b8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "92eacbbc45f1b9e99336463790903a11b1e54bb68c1317d7bfef82e034ab1aa0"
    sha256 cellar: :any_skip_relocation, ventura:       "0183ad5ea71d5b942fcf42f7769413232ac09001a3d1026aa49a13ffb284a8ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d6b5ade99880478906dbb8b5285ef6bc974d6f33601b062fbcc1dcfdc66a89"
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