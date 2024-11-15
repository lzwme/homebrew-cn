class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https:github.comvektramockery"
  url "https:github.comvektramockeryarchiverefstagsv2.47.0.tar.gz"
  sha256 "284ce4a8a4d3e22a392a1ef445354a3b5c93840e92f1a047c5e24871e7e27c48"
  license "BSD-3-Clause"
  head "https:github.comvektramockery.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddd41b76c41ec156c13016666c838d8aa2ed147332c336e28d93531dbd53284a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddd41b76c41ec156c13016666c838d8aa2ed147332c336e28d93531dbd53284a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddd41b76c41ec156c13016666c838d8aa2ed147332c336e28d93531dbd53284a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6a961adba257b28719109d6b22cfe74b09f27fbd41ae8d29f9c14f1df97b911"
    sha256 cellar: :any_skip_relocation, ventura:       "d6a961adba257b28719109d6b22cfe74b09f27fbd41ae8d29f9c14f1df97b911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc448a47c114cb5134850431fc5db0cea5adc67c36a54c4c3aca6c5548006b54"
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