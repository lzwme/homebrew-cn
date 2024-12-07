class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https:github.coma7exxcresultparser"
  url "https:github.coma7exxcresultparserarchiverefstags1.8.2.tar.gz"
  sha256 "760c819c386fd30c8f7083cbfd40bb84d8242ad0647a0a9ed4ed0f48a5a2e7f1"
  license "MIT"
  head "https:github.coma7exxcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a63201752d1a60f50ffcd1b9be6f23b49660e1ca851d193a9df3dc7764bfe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d634968e0e3564ce6f95ab89a6119e944178494256108df362653914edc75ced"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "906a55fec3283e179fcaf2652dd5fd37295ab25ceb04fa5fc1771ff010862477"
    sha256 cellar: :any_skip_relocation, sonoma:        "0269a04e0ea249f09e1d5f657f07684d5529a092a64355b4b73d9a05ef96547f"
    sha256 cellar: :any_skip_relocation, ventura:       "a2d1eb50982aa887df727b6e8d966cd3a1dd570b0d3b10ef006ea41308aa6851"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleasexcresultparser"
    pkgshare.install "TestsXcresultparserTestsTestAssetstest.xcresult"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}xcresultparser -v")

    cp_r pkgshare"test.xcresult", testpath
    assert_match "Number of failed tests = 1",
      shell_output("#{bin}xcresultparser #{testpath}test.xcresult")
  end
end