class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://ghfast.top/https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "6c9556bdc74a78d6c2e50d7fd9949eaa2ba82b5f7f41ac178ca53bfc7247a651"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f945a1d3b2f2e12e03d2c912661ded368efc932b1e05f086d9400a289606084e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1eefee55a3a0af81dcf66a33860281944a983d0ab3c78901b0c7a330703f0781"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dfc64aff2e326dc6dd322bad2035136f64f8396d435ca5b496bd1d7fc0fcd95"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2868d92ef2824f53c042e814af3a46a9a3f0582e4881dcc46c3388967f5360c"
    sha256 cellar: :any,                 arm64_linux:   "1660602cfb35dc1fb574aef68669e847a85dfb98d06864c963de86fb6c70ca5f"
    sha256 cellar: :any,                 x86_64_linux:  "a8d4c46f0eee175a97df739745d41c364c8ebff7babae3b6d1e2c3af0d1d7cff"
  end

  uses_from_macos "swift" => :build, since: :sonoma

  on_macos do
    depends_on xcode: ["16.0", :build]
  end

  def install
    inreplace "Sources/xcsift/main.swift", "VERSION_PLACEHOLDER", version.to_s

    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end