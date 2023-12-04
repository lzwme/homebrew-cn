class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "1.1.0",
      revision: "043ed32135a933a0d9e9e0fc25a4c800c916c3cd"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "facf4444d1fb319f259c23625e3403e427ddcdea43dd4c0ba45b78c8d900ca13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82aa7d8b8a11124fa2c31910d248cd565aaedab61cd2661a304da7c1938c943a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e720f16a9f229b8837bf1ce322b9a8ee71cac23fe7e73a5a7c8ae35d416fc49"
    sha256 cellar: :any_skip_relocation, sonoma:         "e66e0231c9d58ed4e3f07259d78fe45e40b3215147a2c916a2a91ced2e9540b2"
    sha256 cellar: :any_skip_relocation, ventura:        "a1f1825f763c5869e1dfdc33bac90b05b8d7c53ebbaa09b2fd1a61534e7dd227"
    sha256 cellar: :any_skip_relocation, monterey:       "209d418d4f836079ddecae70ece95ab3600ab47b496fba6405f9aec6a4c7dde5"
    sha256                               x86_64_linux:   "a45202a620827a5e6705475c7e1be50d7555b51bee544960952adc83a6b6eaee"
  end

  # needs Swift tools version 5.7.0
  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}/xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end