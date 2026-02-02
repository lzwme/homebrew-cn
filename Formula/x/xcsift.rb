class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://ghfast.top/https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "ffb1d33e2b6aee686d68787e3ad03bf764c41deed3b6d9cff79f76a2c2cee2dc"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf1a90339775a50aa9f6aa822b7bfb754bf958b7403206007bf7cdec0340b9b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eafd4c01c1216fe6d0a5885b2cce47279ab5c6a478dc123bc99398a61a75685"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53c1215d70c9b82b49664a7f3e5cbb5bb3bbf4a338988bfbff0418c9eb13df85"
    sha256 cellar: :any_skip_relocation, sonoma:        "eca5408534b9c2d200e7852dc70e3d68b81da34c31e4925c8c97b295bb3dc51e"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    inreplace "Sources/main.swift", "VERSION_PLACEHOLDER", version.to_s
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end