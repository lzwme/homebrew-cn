class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautify.git",
      tag:      "1.5.0",
      revision: "9895885c427f758a9edfc1c016863418de8e9e8d"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f439e969e62d0cccf60b161d55929be31c0d16a9d8c720a4c1d7b8d8cde06b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a20e4e521819d2116d4d1586cfabee7be5324e498ffa1b13501c3b4918040ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "679809c33ea2e0616ea78e68a0939e9d8f8326f34faf9488e53f8643ffd70e40"
    sha256 cellar: :any_skip_relocation, sonoma:         "eec1c3f90455882a095783259549ebae40f9a3993d1edf600143068260879464"
    sha256 cellar: :any_skip_relocation, ventura:        "614a9368a3d97de5c624812973d4d33ebdf93d603058ab8633b5480cec526d24"
    sha256 cellar: :any_skip_relocation, monterey:       "83348308595a71015790da6ca2529e9ae3be20cce4616ad7604110047b2e1274"
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