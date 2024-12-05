class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.50.0.tar.gz"
  sha256 "4c134b7005988b897c555f9e4117548b25ac3b017658064fc7d26491496c1847"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f317c63992af1b9dd9a6f1e3726fe8dfa07390854fed5c6ac08a6ccc5bf062da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f317c63992af1b9dd9a6f1e3726fe8dfa07390854fed5c6ac08a6ccc5bf062da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f317c63992af1b9dd9a6f1e3726fe8dfa07390854fed5c6ac08a6ccc5bf062da"
    sha256 cellar: :any_skip_relocation, sonoma:        "51ab0c57de67832031870c452a3afb005b7661607735f19981b2d64fbcefc26b"
    sha256 cellar: :any_skip_relocation, ventura:       "51ab0c57de67832031870c452a3afb005b7661607735f19981b2d64fbcefc26b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89bd31e967ea9cef7e2ddbee16652f34716fba45e4fad0e03c81401aaa060ba5"
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