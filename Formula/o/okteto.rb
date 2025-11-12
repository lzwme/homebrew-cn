class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghfast.top/https://github.com/okteto/okteto/archive/refs/tags/3.13.1.tar.gz"
  sha256 "b3163c08862a6d2707a362f9121c17fe1211572c44b01227645633f3ebc76804"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cfce08c15c736a5f7771069e2eb275e429aaee68d7193d2b9c3afdc2745ae315"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e5853e987b963a139f9c70fe0cc54a19a627116860d1d2b47b989352f7b6bf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82a8be07099219d6362834879f00bf351fa7a9104a79b34b5520834a8327fbc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "69bcafee1ff79373607c62165d410ded7a021491a3a89c9b9c225040ea25caa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0a26827292e5435cd9ac8b904d5ded6963d31b25f0d12930201724e5829c743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb9eb74fe175cfb8c547e72c5d2fbf9574f8e6dca0e7a7d6b9ccd2a074c6ceee"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end