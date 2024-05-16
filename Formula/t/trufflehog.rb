class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.76.1.tar.gz"
  sha256 "821d8d67284eff39d0cb56e89dfb74af42bfa4303757b88ac0702f93d68c0baa"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "114462033aa34e675b0073f80db0df5e6226cd2b44266252b1bb7b94500c33de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfb9884a7e6255f14b2e0e317b8f216c2ac1fe37f4db4aa8598e191f1ad903e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a166657da33e314c0c855b5a5e63ed94f5526a4a077cf25e2b338565869cff12"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed98c0fb6f7e83eb8866e913f6a0c0cf3fa68704574436a0c50227d19eb0d374"
    sha256 cellar: :any_skip_relocation, ventura:        "fc60867ed580cc93353392d887a54eb65111a50627fd63f059e9f8e302f5e6b0"
    sha256 cellar: :any_skip_relocation, monterey:       "c486e83a12bb1c99878e1421946018d4fadc6c1317f4b5e2582ca2e1e4e16158"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dd2ef7feb53371d17b814186bb342f8e9aabdace7cee8388f341517ccec6ed6"
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