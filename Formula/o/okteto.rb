class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.27.4.tar.gz"
  sha256 "408302a3ff850f7007a770e01e5eb2b77e209358004f9c2452fb2e5c5b93a697"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b972708faf01ca50ab4fc4758307a261c261b68c8edd83b09292e0bed70d346"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86c2ec8297c10e9562a84df9a999b97b4984202a10d65592ee5eb91e2fa7eb16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb3bef2c48a6dd887d578738a938e203a383784f2554ee68ac9a8ce5aef83b2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "627281b1a33dcb3489516c08b7994c2f3fb037446b606998245e045e0d561a07"
    sha256 cellar: :any_skip_relocation, ventura:        "e27100a52976015898c9c747c2a3812e32a8e32f4b84271cefb55a242e3b0878"
    sha256 cellar: :any_skip_relocation, monterey:       "e7faec56afe969c08261196a70516c6e8836e5d16141ffeed1f67f58738da0ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "619d3b1c1a457939e23a1d2b5f6ea6fb4b430974e157c4302839723861cf4a44"
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

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin"okteto context list 2>&1", 1)
  end
end