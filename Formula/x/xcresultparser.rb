class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https:github.coma7exxcresultparser"
  url "https:github.coma7exxcresultparserarchiverefstags1.8.1.tar.gz"
  sha256 "6644f6f75eb334cdc09d20acb141ff797d3d60f9fdd37c638a1a14771f941ea0"
  license "MIT"
  head "https:github.coma7exxcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bbd9c81f285a02ea3178831a3dca33f356d6755e77ba464ff14bebfe96b46a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73511f0a89d1161b78439bcad7a53e378597cd63abae10f5ebad40f9fa87e91d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "701228f543792efa43da2e856015eccde4e571db754d90600e8b006ed244bc62"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb3f6f6010b72659ce94ac5e4235122b11b0d01658c9f1745a0bee1dc4ffa77"
    sha256 cellar: :any_skip_relocation, ventura:       "00bd52c9b3a64da78d12fe2c9497d53c8e8ac84f4343b66b7ce08ce7032b089d"
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