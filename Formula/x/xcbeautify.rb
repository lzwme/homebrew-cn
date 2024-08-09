class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.10.0.tar.gz"
  sha256 "e4da3d495915e54c4be99e83e51fa1427e71a311dfa08d96bda20681df381e6a"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c4673b499579f3cd3c007119c11b9d2ffc85f018c407274d9db04d83ee17694"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b5fcd4192ecd883a5f2daa26892b79eeb15b2ef3823ece0430081b334a83ff2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cdb37822c464f1888975adb88992f50cbcded7c81e49bec9d4eba76786ae30f"
    sha256 cellar: :any_skip_relocation, ventura:       "eca6253b0fb8b3ca151e25d224b586097d06a8c418471aeae48bc04e228b9f5d"
    sha256                               x86_64_linux:  "b55a9b8f98f4d7d6c22fc62a5447942b7ed33534bf12edaed19dd100803d44ba"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

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