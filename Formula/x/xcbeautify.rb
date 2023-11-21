class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "1.0.1",
      revision: "7dc31d4a9e9cc660f2de6ff6c6e0f0d5dfbb572b"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a5479b847e453d31a6f0db5dc2025a7cec02a3abee949633f3d4b933c63d4bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65c88205f9cad6b2decfc1822e020474e29f39cee2b0829e5ee45d730f916dff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07d7483ef82ce4f8e5454192ab57af31081ddce1dc1a59e0b78047083b3c2d46"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba9a4d02d7c11272c5772a751d6e3429071c208f599c6f72359a59db3ba7ab50"
    sha256 cellar: :any_skip_relocation, ventura:        "28704b049d5826632dca6a0d4df678d9420debdc6e72b7d9a74569fd6ad749ca"
    sha256 cellar: :any_skip_relocation, monterey:       "698a79eefa07f2bc8371961ae59efd863fba1dab4c50cca0a79d935d9c42cffe"
    sha256                               x86_64_linux:   "8bf201e9ccf569c24001db8c4cf14d86272de79d844a6e24c3f63a7d5a391a89"
  end

  # needs Swift tools version 5.7.0
  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift"

  # fix version report issue, upstream PR ref, https://github.com/tuist/xcbeautify/pull/159
  patch do
    url "https://github.com/tuist/xcbeautify/commit/af3847b6a3bbe1142c055fc968f20322788bf3a0.patch?full_index=1"
    sha256 "863884832585c19cce03f9f10dc4e38575ec44f74e2d235c6654a6301a6a8d5d"
  end

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcbeautify"
  end

  test do
    log = "CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)"
    assert_match "[\u{1B}[36mMyApp\u{1B}[0m] \u{1B}[1mCompiling\u{1B}[0m Main.storyboard",
      pipe_output("#{bin}/xcbeautify", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}/xcbeautify --version").chomp
  end
end