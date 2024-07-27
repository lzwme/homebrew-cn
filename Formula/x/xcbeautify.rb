class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.5.0.tar.gz"
  sha256 "008a02319b5177afed8e8ccbca9eabdb0c3b2a8b4fa0955c94d4b80440e3b639"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e03d8ee7b5872d2bb6fa2404f66db3f04c1482028565568747cafe996210bc78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf1171568f6953ac9218115dff61bb3c1cee10b1981013ef3705ee03a04d7469"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d67b5ec13c2435f756c4e96e3fdf5c2a99dccfdc5d63b1f2b1ae8e546dc6b16"
    sha256 cellar: :any_skip_relocation, ventura:       "8db5e9f777c238471ebc20af1c1dffee48a5098823e63d552b5de5f6aabe7b2a"
    sha256                               x86_64_linux:  "bc58ecf2faea5d66c7b8d4affc705b3e82cde072052c72324874af5de9156c8f"
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