class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https:github.commac-cain13R.swift"
  url "https:github.commac-cain13R.swiftreleasesdownload7.6.0rswift-7.6.0-source.tar.gz"
  sha256 "7bb66abd5ce75b134af273233b9349602014a7cd28013fd6b45583a26b05ab9b"
  license "MIT"
  head "https:github.commac-cain13R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46bf95f95abda84b94362057c7ca6b73f8f8b19638db058450bf1ef27847a1e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "069cc0a8cb4e402ca072960c771084862c764f14a9a5247f0d9d6ec4f24eecb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4282704210ad606eb3e77976f2d616696a9eeac2eea0853cc59c9dd636b60b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2dccbe84dce984db43881bbfb19f782091f72b376e85f082f5e56d3e8df1071"
    sha256 cellar: :any_skip_relocation, ventura:       "670a4623868bc4ef10cafa81dd174defb8370e70e7f7513c597d96946c70de8d"
  end

  depends_on :macos # needs CoreGraphics, a macOS-only library
  depends_on xcode: "13.3"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".buildreleaserswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rswift --version")
    expected_output="Error: Missing argument PROJECT_FILE_PATH"
    assert_match expected_output, shell_output("#{bin}rswift generate #{testpath} 2>&1", 64)
  end
end