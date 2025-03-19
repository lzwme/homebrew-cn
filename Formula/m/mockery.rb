class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.53.3.tar.gz"
  sha256 "c9495d19de1ca52a61a9ed299d9988a4f4a3cf1ad614954a15ca3920d8b852a2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ffd0607ba8cc90b53782de55f91a711714fbc4e6f7631dbe83fba22c3aa1899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ffd0607ba8cc90b53782de55f91a711714fbc4e6f7631dbe83fba22c3aa1899"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ffd0607ba8cc90b53782de55f91a711714fbc4e6f7631dbe83fba22c3aa1899"
    sha256 cellar: :any_skip_relocation, sonoma:        "632dfec12664f5b60b9cfae077d1953a55e65b16662b425e522fa79b409e9d40"
    sha256 cellar: :any_skip_relocation, ventura:       "632dfec12664f5b60b9cfae077d1953a55e65b16662b425e522fa79b409e9d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fdbb953057fc8bf3a82a94740643996c080162537ce4e0d6b541cbddd769cf0"
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