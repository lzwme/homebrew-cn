class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.53.2.tar.gz"
  sha256 "dbc2acfa0bbd1a6cf7fce0d8b70b71b234950762377be644cd4614a2f34ce997"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a13707021e83660f528c699c1937d5ab11da18dcb1d0056896f1bc52dddcf2fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a13707021e83660f528c699c1937d5ab11da18dcb1d0056896f1bc52dddcf2fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a13707021e83660f528c699c1937d5ab11da18dcb1d0056896f1bc52dddcf2fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2390ca1d351b61904519f37727122a4e32a923841e8dfc375108eedd74690c34"
    sha256 cellar: :any_skip_relocation, ventura:       "2390ca1d351b61904519f37727122a4e32a923841e8dfc375108eedd74690c34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0048be149f00ace3c36c02e0fa566694acc57a8a3a063bbfd7d3ac55121ec27"
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