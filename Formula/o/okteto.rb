class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags3.2.1.tar.gz"
  sha256 "5e2d42debd18e5d0c772bc8196a915dd546136bff8d876345462aa494b275482"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8b0240a7da048ec97219d733f12136aa96e91340a3f251f5bca40ab6c849d5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab06a4d9e57183baf9a64debf3b511bea43908d812d40fbe4395024dc9521a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7602130d5ead9774f0bb25eaae29d690e9a6786d87085bb4c5192a2451fe1ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bc6d5db4d1308b0ef2313eb18adfccfb8b60e0a8f49e14fb89c6b6026d754cb"
    sha256 cellar: :any_skip_relocation, ventura:       "37e95c728e210d2044d3f2749aacbb73b9c821f6b35c73c69c7c9d1a1baea97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c744051d81e4be8555708da6fc31633f2fe6b0ab31735f0f57e83bf5e5e8ac2e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comoktetooktetopkgconfig.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}okteto version")

    assert_match "Your context is not set", shell_output("#{bin}okteto context list 2>&1", 1)
  end
end