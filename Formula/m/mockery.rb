class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.41.0.tar.gz"
  sha256 "0f9ba7d71c035ea30e2f3953fbf4fb9cdf70071fe7e18a02a4950f2a42fb442a"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48bb3b468b39744a6d9d52368c1b373c08491a1b42d7d83691cb862d132847bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8a7748e72a89ef9cdc899932971ac9b76182cd8f65f4380e88f957c5fe204b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83428afcc10902fd9576fea14860608602ad236b872bafe1b6245c556d818c9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0de6a21056b5391859878e7840fedef6f0422ca83b9fbed7255c3965c7965e1"
    sha256 cellar: :any_skip_relocation, ventura:        "3433e9d5fae7a335ef5e892bd7ad8f05921a874fba6f413581cf838cddb97b1c"
    sha256 cellar: :any_skip_relocation, monterey:       "4a10715fb128f3510a24d7376e50e61b148fd36a1a3f1017c8cf431b85829be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e979f833e469077bd0f36ea6ff9777469d0fd126e58d275fad95e6662e8716f7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comvektramockeryv2pkglogging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end