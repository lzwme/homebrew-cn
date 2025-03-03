class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.53.0.tar.gz"
  sha256 "3f4685cbeb30f9be4cd97aba27d6df73313ff5a7d2e0a4b576dfd97a92d4c2cf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7a562f40f95765419d6493f6f619517e1964002dbb57dde6f7f475737a04e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7a562f40f95765419d6493f6f619517e1964002dbb57dde6f7f475737a04e57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7a562f40f95765419d6493f6f619517e1964002dbb57dde6f7f475737a04e57"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5a4699c80048e29f8ca4c2a2561b652f079b541939d19f2295c91814ed10c75"
    sha256 cellar: :any_skip_relocation, ventura:       "d5a4699c80048e29f8ca4c2a2561b652f079b541939d19f2295c91814ed10c75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8603ab953208a7d42cf08eb55f7e95b67c44aeb693883bbbea51924ac1a920e3"
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