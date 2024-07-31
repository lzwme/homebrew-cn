class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.80.3.tar.gz"
  sha256 "6eedfde11ede9fc4ab2e94731f87fd5ad2b4ac3c34f999a3a606f63118449485"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13d20c5ddcad677a06d31d56d84738afe4c66d6163bb6ba22b6a77d3fc5810c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e1aea1d7edde098ccc1794b80a92cba1ff0215abb0fcf910667cacefc34a00e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b15f9e615fd6bba011518047b56731b13646e9912c12f32c114cd0dcd533422"
    sha256 cellar: :any_skip_relocation, sonoma:         "2651dd89b93938c13d0f59a0f37110fbcaccb4ce5dcd7960139b02e91682700f"
    sha256 cellar: :any_skip_relocation, ventura:        "871460b99c8c848da6540a8e4751b28fabd24c3f794627759bec2e5f95a945ff"
    sha256 cellar: :any_skip_relocation, monterey:       "9d9978bf43d1d3abbd6e3c445ec05fc84184181d7256045cdc9814dff5576c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e2d1edf9fcc1b379a58997a7594a03c6133890e91c29aeb9f13083c4bff471"
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