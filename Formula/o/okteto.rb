class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags3.5.1.tar.gz"
  sha256 "45f6277ab79c51a21e649ff02aa6b3321b333721efa176b9877a263776b59b47"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9272bce2897ad66047f6ad1f6e6c3014a85c10e8f1712be21018494f90f06dd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd268c545414ca5bfcb86248a955d936e574c9044358fa93dd8e9130b71de0f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "153b6034fc77af4d807a97fab522c89e9cf08616d4a66ca2b4c2f007a5368f17"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b51042ff60845a73611688396523a60a956f9736e533400d129f81fd6c9b0b8"
    sha256 cellar: :any_skip_relocation, ventura:       "45074f7308f0a7fd2993112726732db361457e201320cc3f9839ca07031fed90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8316107f8396bda4343f3c58e37998fe7475dc59f28327153e8a645c870f2d96"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Your context is not set", shell_output("#{bin}okteto context list 2>&1", 1)
  end
end