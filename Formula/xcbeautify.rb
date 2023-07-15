class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https://github.com/tuist/xcbeautify"
  url "https://github.com/tuist/xcbeautify.git",
      tag:      "0.21.0",
      revision: "566e8fe7f739750e5b938182f583fc2c1f916373"
  license "MIT"
  head "https://github.com/tuist/xcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9d88773454180a9b86b3ed32c9e35225c2d966c2e50ccbf2fb99f4a25ba8a3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d42e2c71c49313d2ba773a29cf0123a5870c0d890e936d4b7bbbb12a11c98792"
    sha256 cellar: :any_skip_relocation, ventura:        "bf74545c26178ec39274598d167e20fcd598a12f6ed39d1d166d2745145c6468"
    sha256 cellar: :any_skip_relocation, monterey:       "8fa038c02dd0bb20843e9eee4da25efa28590519b1801fd8b60f5e7df5f7e82c"
    sha256                               x86_64_linux:   "856e06d7bb87c0298d1e648c01d9f78c4893dcacce4fd3899d6d9bb7ca898cf0"
  end

  # needs Swift tools version 5.7.0
  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift"

  # patch version info, upstream PR ref, https://github.com/tuist/xcbeautify/pull/137
  patch do
    url "https://github.com/tuist/xcbeautify/commit/b18c87653ed0d744be565609be709a84eac2e7dd.patch?full_index=1"
    sha256 "75a13bc9632f9008b7506bc3d2f6f0f23c8dbc302c10fa086d60ec78bb3a2a6e"
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