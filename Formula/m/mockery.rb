class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.52.3.tar.gz"
  sha256 "8677c487e91752928f60aa49ccdd08d12f95d45b99815595d7fe0372675c8711"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb72960c5adccce9ca7e82513bb5f6aab03b2fb8a4da82fd14596c71662433d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb72960c5adccce9ca7e82513bb5f6aab03b2fb8a4da82fd14596c71662433d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb72960c5adccce9ca7e82513bb5f6aab03b2fb8a4da82fd14596c71662433d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a65973f24f13e31f82438ac04333b88d0e43b61cfcf100ff79fa055950b8f94"
    sha256 cellar: :any_skip_relocation, ventura:       "3a65973f24f13e31f82438ac04333b88d0e43b61cfcf100ff79fa055950b8f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9398da98b7c4eac70cb83895b7b767f1f28c8ffa3b90174ff2f3e7390092c3cf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comvektramockeryv2pkglogging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end