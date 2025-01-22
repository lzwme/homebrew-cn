class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.21.0.tar.gz"
  sha256 "1585e079ce0a2d066d6cc2e24fa1034b5ff9a197155b090496f8e86a584c99d8"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "661f365b474742790013b2851486176fff64475afe7e66044bfa2989b90b753e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00ce3c64cedf63bb4276758b3f71d2b7058d2d264b157471614537e8815880e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae7efae73d99d927b1072a492c0f0040ca2c4f291adc415140d6006dbbdc8a5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "94dfa232fd1d1394b7f567275d8f648f59340e8b4ea9e25931a39d4149f865a0"
    sha256 cellar: :any_skip_relocation, ventura:       "f876da3cfd8a2e3a8083e1d49108ab59405d908f4fcd80b58c197bbd47a9dc43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53f86e75ca7a532a045c0668966771113beaac83723493689aa3f3caa6e5e822"
  end

  # needs Swift tools version 5.9.0
  depends_on xcode: ["15.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
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