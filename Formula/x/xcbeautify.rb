class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comtuistxcbeautify"
  url "https:github.comtuistxcbeautify.git",
      tag:      "1.1.1",
      revision: "6ba826167c6b301e7adeb35398cf7d1c27367661"
  license "MIT"
  head "https:github.comtuistxcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03ea177ebe6523fcf9d66b803be30cd69d33ef568ddb427ac6a68831e3c6c099"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1178ed1f6daf583146d4f77d4f663da7a13ae49328a89b76715a2622b31abc54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfbae7dee353e1b7db2fdd59a927eb0cd7453f74ee0dd28d31ebe38cbcebf1c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b4fc2e0e7ac03d64245b78fa468c6f8bb1f53abfdd7086ecf7c966f20e03929"
    sha256 cellar: :any_skip_relocation, ventura:        "976655bbef0b025797e0edf97c9458847a3b0fea44a219bd4f8c239474b52165"
    sha256 cellar: :any_skip_relocation, monterey:       "c0ecedb4137aaa9fb7f674a8c3baa0b032f817015703bdc61466fadbf6f7408a"
    sha256                               x86_64_linux:   "9e454e83035febef8759da67c6647652272727df6d66e079a280c10c19a194c1"
  end

  # needs Swift tools version 5.7.0
  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleasexcbeautify"
  end

  test do
    log = "CompileStoryboard UsersadminMyAppMyAppMain.storyboard (in target: MyApp)"
    assert_match "[MyApp] Compiling Main.storyboard",
      pipe_output("#{bin}xcbeautify --disable-colored-output", log).chomp
    assert_match version.to_s,
      shell_output("#{bin}xcbeautify --version").chomp
  end
end