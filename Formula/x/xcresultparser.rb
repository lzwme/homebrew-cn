class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://ghfast.top/https://github.com/a7ex/xcresultparser/archive/refs/tags/1.9.1.tar.gz"
  sha256 "22f897ffe9bd55eadc85c3d4328514caaeea1e0de49f35cbf07aaea9ad9d900d"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37329d14b04e9671435517b5b497999d14136cb6c1a174d943d0643a48b9d924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0c357a0b9be15f04e96f8d69e76958f17d00e3e4e365cbb01ea31eac5916c8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ecfa5583a0a9fd175e13df5bf81b5809bf19ea4e0626b72238c921c9c84c762"
    sha256 cellar: :any_skip_relocation, sonoma:        "020f16b663a2fbcd385d11c25684e553ef781ad8b084c7d83bfd8b755442f164"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcresultparser"
    pkgshare.install "Tests/XcresultparserTests/TestAssets/test.xcresult"
    generate_completions_from_executable(bin/"xcresultparser", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcresultparser -v")

    cp_r pkgshare/"test.xcresult", testpath
    assert_match "Number of failed tests = 1",
      shell_output("#{bin}/xcresultparser #{testpath}/test.xcresult")
  end
end