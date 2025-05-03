class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.88.27.tar.gz"
  sha256 "1fea477d8e87a5b76b2b0344a5f4e4e1d087ee3b89ec6ba7ccf728dbf38f79d4"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45b4ec226a939d46644b184851829af78e11d5c2d8287c2d6d4becedbc315092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb6febb332d11b1b1143a319a423045bd4648a7291235cd806d98088c9be28b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "104b7c48ecd33001e9c63e3a9a1d6b9d4b67d1ed0b9dfd7f4b442c45c0a4a13b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2604a26501df7deb65d6360c041618f2573ca2190e41018d1e71b152478ca4f9"
    sha256 cellar: :any_skip_relocation, ventura:       "d3ebc68f305c31fa1a7e4f49688a33b6c668cba9bb685d2448f8bceeb06506e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62f52262c87e8a6c453a9925cd1ca8080c314a8d1ba2dea66b722448e45e5198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8dc4b0e0fe5a532379fa9f5484b9f2687224451cf61b74de1e3a1b3e351a760"
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