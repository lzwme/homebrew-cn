class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.50.4.tar.gz"
  sha256 "b5ebe37c8185492e9f432f3fb7aaaa0ccdef90784fd4113eef14e3a6ec324c0c"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dc749d968ae307b235a27606ecf90e447f611dd037bda3b10e01c756edfff98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dc749d968ae307b235a27606ecf90e447f611dd037bda3b10e01c756edfff98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dc749d968ae307b235a27606ecf90e447f611dd037bda3b10e01c756edfff98"
    sha256 cellar: :any_skip_relocation, sonoma:        "b34a280caf2f0c4a8ad2848957879b9eac01bcb61870de0cb706bfa9e4bc62b1"
    sha256 cellar: :any_skip_relocation, ventura:       "b34a280caf2f0c4a8ad2848957879b9eac01bcb61870de0cb706bfa9e4bc62b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62a3585db706f7eb7ffdddbdddaaede249d896a4934104b5d70309fd58a90285"
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