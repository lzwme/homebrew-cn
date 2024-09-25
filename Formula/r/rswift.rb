class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https:github.commac-cain13R.swift"
  url "https:github.commac-cain13R.swiftreleasesdownload7.6.1rswift-7.6.1-source.tar.gz"
  sha256 "163f8b2cbd79a97a623efed2390f963aaa1896b78cc6a31751735548a2d26f19"
  license "MIT"
  head "https:github.commac-cain13R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13aaaa5eaa1d84c93cbafc08cfe6559b890314b200c4ddf0f13b96c129e090e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34559709a78e20f60fe7f93715432175d72fc98570f6fa0499e359f9f85eb781"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fcc5929f334519fcb542e3bbc27080750abfb5d29a2f327da44e529be29d8123"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2eeff4e1ca5f4e354b32d759f88eaa911ab9a58a61814996e7694ec0a0b0ed4"
    sha256 cellar: :any_skip_relocation, ventura:       "61db49c1a5a42693cf4a0d2f97f20675cc8abc87614149697ae7b972c6b4f6ef"
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