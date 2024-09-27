class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.82.6.tar.gz"
  sha256 "b5dcae8b71d4b568211240f8e1b184fdffcc478370ca8237ed38f954a96dc636"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a327feeddcb150b7894405abbe58044dbd68bccd3df63305bd35117dad23fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "087559d642493fc4f85c6bf51863ee4edb9be551a42078d2ae09f1dc045e522a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2eea9b486d19bf51a289036677cb08606a73601f2fce151cf1d83fe3b9b8619d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ca24c842bc4111a319ee1308b1686dd0ad0105f298919bea0bd8c363c9e9845"
    sha256 cellar: :any_skip_relocation, ventura:       "482d1bfb54f6947387cd407deedf304bf197ed7ccc1cd85c65f321c8cc64e5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c916f38bb2f6e7fe8778dfe39815e4892a5dd2513a6efe558ececf5c065f40f"
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