class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.12.0.tar.gz"
  sha256 "8a41284136fd445404cb3a09f24b3a990db78caaa0a7847d0ef77e10072be789"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aa098e2d729bd926a99037277465fafda55cce0088fb16fef7c302e4ef2c433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdbb0f4dd74e5405fddbfbe4238e5bd9432624d489e1e1dfb9e347ddd312f4b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab00da93011240464ef2393bda2386d4bf6818c78eb2d59ede8f91930aee3804"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec115209994e4c4249b1d7b9ba5f1d93be658d0aa578c15f90d84a51dff867c3"
    sha256 cellar: :any_skip_relocation, ventura:       "a8817ea7690a5d00d884341c38693893d3de0b8c8fa50d3dcafb2d2b58344083"
    sha256                               x86_64_linux:  "1078a436072a1f4a731659f3866de4a15b0665d46f36f1400bf72cfdaaa5cadf"
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