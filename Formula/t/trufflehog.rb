class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.67.1.tar.gz"
  sha256 "0189700c94702e20cd15cf63b0f6b4afc5ff97e6e395cc2423ad2ea52927fb0b"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15c68a0cde88602bd01ce8a02c0aa3b2eed4110d63e72becf0d4bb5a39b2abfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8aec6ca9a8af69cf0b8ba205f5e2ad698411894c3ee73e7c5367d7c1e56bdc58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6770f2d506a76dc25cf8c6099d9fddc9e77e118cb38472e4ff6e4c6b59e35f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5142b4ea76d39493523edfd437f654d42cfd131f665ca13905c027f41d430994"
    sha256 cellar: :any_skip_relocation, ventura:        "b5cbb8a15cab20658af874d8ae11cc539354f397f3c87273ab7597fb57f41460"
    sha256 cellar: :any_skip_relocation, monterey:       "2f4b3fdbd3037debba0c1c1987f69d88134f28a5df60f650e418cff265886b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "785f74dde8a9b143de6e7390b76ebf20f4c459873ec673ab9f6ec1db3685426f"
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