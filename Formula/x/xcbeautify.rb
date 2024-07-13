class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comcpisciottaxcbeautify"
  url "https:github.comcpisciottaxcbeautifyarchiverefstags2.4.1.tar.gz"
  sha256 "cf4ff79357a3e6ef4ea9c8b9e8fb46cf6400701ef0064e1b4ba00a1c4846ceac"
  license "MIT"
  head "https:github.comcpisciottaxcbeautify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69582093b0a06d7ed3b03b82b29be5723ba6e46f8a7546c59ce1fed364f51701"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72665b9f9c4d515857bd3545eff067fe37b003f8010bcece75e82f11fb71593c"
    sha256 cellar: :any_skip_relocation, sonoma:        "13e8b932e9b7ad308040b3b124fff8acb772e0ab971b253faa36cf1b28c5aef7"
    sha256 cellar: :any_skip_relocation, ventura:       "f337f20e6a7c7683e26ebdc799423551bc44183283466aecbb7710d5a0c9e673"
    sha256                               x86_64_linux:  "63cc0e584f5794b0851fb9abefafefc54215812846299f7782ed841809f7ce6b"
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