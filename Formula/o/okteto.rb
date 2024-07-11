class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https:okteto.com"
  url "https:github.comoktetooktetoarchiverefstags2.29.1.tar.gz"
  sha256 "292317ccad15372dc54a057a8bc12cc15b7be5ac13f76b6210fd4ff46795bd6f"
  license "Apache-2.0"
  head "https:github.comoktetookteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d165c6a8199a5338a2892d77a859f834a14367420a1f94ff04f072e784be750"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "141eb64a058507c4371525ef2b5ecfe8b102f5e91845d193e6c11982cbb77533"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bd2f393029f61010e16fe1c8feb1ab83ce52caf0659e5bcc73c4e7186a77ec5"
    sha256 cellar: :any_skip_relocation, sonoma:         "620eb9fe4dfced6f3beaaa49ba7effc6bffc416f93ec0ef9db30854595ee1d06"
    sha256 cellar: :any_skip_relocation, ventura:        "053d64d7581ab1d92d0b0448f2fd09e049156189f51eddaa9c2db6d1fa1f5426"
    sha256 cellar: :any_skip_relocation, monterey:       "cdb2ff76dbe9549d1760626953cf006f849fa1ba227c826fa7c9cc8932315dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "000c70e2e54fcb04ad80f2e96a555aeca4e07e7895b61ffec969c265a9d1898b"
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