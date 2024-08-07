class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.8.0.tar.gz"
  sha256 "ab61627c4c9d9c2356568c69012241d7bd42416879cde7dcbed3eecb51b23dc5"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7ac1dc3451331c25f137a6e04c0730f348dfec81372d664b5df3b9f22d403a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "345efebe0693fcfd695a855396b8af13bcaed70004324b2ada6c0e2161282300"
    sha256 cellar: :any_skip_relocation, sonoma:        "179081b6d1df180be7c09c03bc04748000a5dc3f32b53f323c6f070d2e846be4"
    sha256 cellar: :any_skip_relocation, ventura:       "b38709a911e7b4ad5cf32345031e0166b0cebc174c0766c963147a3b871548c4"
    sha256                               x86_64_linux:  "d73a67c4c14ab15a7400e31217057fa690238ba3d4fdf3f4f1934fffd5ff5500"
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