class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.87.2.tar.gz"
  sha256 "830b6282b39a1f0e296d4ca818900ac4eb49ca868abbdc444841c24e525b2f42"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97295f89683c31bea46a8612dd7daedd1c7bddba0512cf5caeafbd2a9e975202"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7242071c810e1f3ec3b6987da42fae3e7f94c47dc3587201a9216caf110d9e6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6aca4a5fef8ad09300570a1c6ca8b4f30a1bdc6854790eb0cb64c539670cc10"
    sha256 cellar: :any_skip_relocation, sonoma:        "285411b93d1c28c7b54cd3072abf5c4addb2b628245f5bf1b6c94eb5f6d2b888"
    sha256 cellar: :any_skip_relocation, ventura:       "f89f88c3dd191596e1d6b0bd6bcdaa7f0dbf2b8d14bef300d0644328f7ffac3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "324a9273d1a84549038415905a5472eb5513fba9695ed66636a77a30793fc777"
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