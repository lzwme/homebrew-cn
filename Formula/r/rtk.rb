class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://ghfast.top/https://github.com/rtk-ai/rtk/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "ca19772378422756c5ed2212e228986cfc5e791695c5025317b58fa475d4c427"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffd89cf87a75470967c0c1b1e4cbdbdcb3286a43e9027734b29202f6f0ef268b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f39960744078061a8caf99e9e0a31c1dcdad028359efd8421cbeec7e566e298d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91c4fb0d6b0f8c91459cfa0d0a5ce77765e118161c290e9eb32adf87b4128fd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "26ba4b60dc11ed075de0ea9cb69415b25fb5d1c5e50dcc93a0e196f1b84f9c84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39e630cd5995e398018f3d708470bbd313112bde51e1328e1a3cbe4414841880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3fb1c092f25a3a992da43a7f4eb2d8ce96217bb9432af30d53fa56080ebfaf3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end