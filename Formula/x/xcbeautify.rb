class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comtuistxcbeautify"
  url "https:github.comtuistxcbeautify.git",
      tag:      "1.3.1",
      revision: "b8abfc46b38a77f0d1768ac041c5130fec331541"
  license "MIT"
  head "https:github.comtuistxcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7c1cfb62a937d7fdb3926605e83818df5f96e394b97d40528b8901891280c12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a53f555296aa04d6968db2432683e2f2f7730b1683fc63b98d5f4cbea7e15531"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6b4ee7ca8fac8a3a87cf96ac756d174c821785954c53310c289f523155ded59"
    sha256 cellar: :any_skip_relocation, sonoma:         "20ba46b8790050da0804266c816583f59d8c9d62b01e74ecef9b2c928909ea57"
    sha256 cellar: :any_skip_relocation, ventura:        "c7d5f95b9d33f9b64dda94fa6f449a91ba6c32ec6348589c99767a40974479b9"
    sha256 cellar: :any_skip_relocation, monterey:       "e5a2ce6d8328a0548766aceacf6974a3f7460c18c33aadfdc304b7972fd3e66f"
    sha256                               x86_64_linux:   "2fcf1007ad7a64c839d44964e0dedcb8f1af6f59126c0cd62d74cf439c9ba8c9"
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