class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comtuistxcbeautify"
  url "https:github.comtuistxcbeautify.git",
      tag:      "1.3.0",
      revision: "eec382da2350ea33e7d0f172d53ab7f130b04f18"
  license "MIT"
  head "https:github.comtuistxcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ee80e34c96c32b361a47b5aa46588a5e1acebd7934a824c6c25c4e8912ad6a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd1017dc96572a4df2340fdd52a70b43af4aec2fd6c0ea0005986d421e44fa20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35b120a96bd8738c10e42158cc3e03152c3c39a18be196a15c564905f0cbe72f"
    sha256 cellar: :any_skip_relocation, sonoma:         "08f46691bf5e1b8c0471a36a38d09b9f524ccfc05b74cc117ac0eb71c59d0513"
    sha256 cellar: :any_skip_relocation, ventura:        "ff0ff2be73a17d35844e3e0b56125daf233c114ebdb67ccfa979e8e80da5f055"
    sha256 cellar: :any_skip_relocation, monterey:       "45418d59b7a45ffd9f4d532d35dcce5a5fe69df1b7e1b79cdfabc9261473339e"
    sha256                               x86_64_linux:   "5d7a777694dc15389faaccafacc17a35293cf33cd9fdeae7d4710daf817df406"
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