class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https:trufflesecurity.com"
  url "https:github.comtrufflesecuritytrufflehogarchiverefstagsv3.81.8.tar.gz"
  sha256 "b4c576fc07d223feb1dc1289955ed8446f50ffa57438a0a6b7c70e07c80e5f14"
  # upstream license ask, https:github.comtrufflesecuritytrufflehogissues1446
  license "AGPL-3.0-only"
  head "https:github.comtrufflesecuritytrufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22e65d57d5ed38a9c1543596b15d2643b162762a56e45bb0197e66025eac874f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94c2694eeee8640e407752e332cdde400d278951f08c0c9367a87e8002423de3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "741a170ff15058c95e3dc68a216b76f2dfcdf2409a20880ea3d717413fca31b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a07415d99afb377368f6b29f41a138c0fb4849fa9b564e11120dd12d2afeb8bd"
    sha256 cellar: :any_skip_relocation, ventura:        "f6682fc548d93c578d9f50b66298fc7c82eeaa448f5f1734639426904a8d4f01"
    sha256 cellar: :any_skip_relocation, monterey:       "fc389b5cc3873eecd5acd5626f5535a1880a04fda30aec3f1b9daf780cef26c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c1c74df781c31fa42b534c43f7163cfdad2c17c59c4b2179a63ab4f4f4ea650"
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