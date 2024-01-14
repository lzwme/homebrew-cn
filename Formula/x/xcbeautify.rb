class Xcbeautify < Formula
  desc "Little beautifier tool for xcodebuild"
  homepage "https:github.comtuistxcbeautify"
  url "https:github.comtuistxcbeautify.git",
      tag:      "1.4.0",
      revision: "84d24a9854e6fdcd2c91122d50a3189b072e8136"
  license "MIT"
  head "https:github.comtuistxcbeautify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c75bfe4897c0060508fbd3202c98b12aa47e55de67d01adcbe76e58d6d8bcb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8707a487a97a762688e9379b5661f50e1f80570064a5df1666212e517ff466c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ebcf5e6923d61d699f0a854a2431ba3d60a63fe423ad48b108e408c422744d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "6810a7c55bcf73642fc33608b5c91c5bfb473067f599bf2e50d2bb8d587a837a"
    sha256 cellar: :any_skip_relocation, ventura:        "46f240712c005ec66830c07923e7f67aa42bd3b3eb9db65a537a086c9b3d9120"
    sha256 cellar: :any_skip_relocation, monterey:       "1ce33c69b6fc25c8e45f13c43fa44d9066e304df7784b9a60f225edba832e634"
    sha256                               x86_64_linux:   "8f6268c784eb1b48dc51e4fe5103dba359e30c237f76e1f0beb705b7dbe6afaa"
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