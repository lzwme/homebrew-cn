class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https:github.coma7exxcresultparser"
  url "https:github.coma7exxcresultparserarchiverefstags1.8.3.tar.gz"
  sha256 "7b66a269132379f42617f9338892a28f5695010cb337581007ad8cf6bad7c128"
  license "MIT"
  head "https:github.coma7exxcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8872ca6d521bd9d2b5eaed72d9a0cb7d93fa72fea9af44b1b2f389c5bce1df8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23721a36ccdd1d0e8ccb069482333a9260d145c86609cf4a635753f7f76cd11f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0a26438bbdc7ab721e57ebf88ad6dee0bccc029f9486a8ebc3c41fa620f8200"
    sha256 cellar: :any_skip_relocation, sonoma:        "6621d94cdf92e1f517a4ce7eb87bd956f86bae53f5bda1ff69f76c257634244a"
    sha256 cellar: :any_skip_relocation, ventura:       "231fe644267200384a7a32c3f629eddfa4cac93ddf9d728ff8eef52ba7f65f0b"
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