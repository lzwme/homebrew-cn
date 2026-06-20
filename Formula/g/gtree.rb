class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://ghfast.top/https://github.com/ddddddO/gtree/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "a5e1d360ab3da8973aa3b2010233479d2895101ee8c6023ab320557ee644cded"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cea794f4aecc68828afe59044765c9d678adc98fa32e35c3ff6fc279130f68b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cea794f4aecc68828afe59044765c9d678adc98fa32e35c3ff6fc279130f68b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cea794f4aecc68828afe59044765c9d678adc98fa32e35c3ff6fc279130f68b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e29fe46330413a102545697c35570b9a1b6008d4b0f394e134de5d3b495c4b40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c97c3b289510d45f5cb374f80c59f78841c995aad678c9e3e9476f07bc6e728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "585bd1a989836fa735d7d2f3e9727491464acc166f3401c8f80869e238e50d4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end