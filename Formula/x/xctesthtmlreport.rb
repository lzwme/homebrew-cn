class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://ghproxy.com/https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.4.0.tar.gz"
  sha256 "d6d9d3b4c1c2dba1068909ef94e90cdd99039485845afca12f4bf7ac8964807d"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9d5bbae56b3d378cddef569fb6a18757f79c2a3cb75d7dd5c8af24a6c5e002c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c496fd126145499f7a92251d022b3083807dc0bf04cec23e8a27db3ae28fa79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4004ac815f976b0d716b76fc84aa4ec13007a4f5075dc1056ba670c751e7c1df"
    sha256 cellar: :any_skip_relocation, sonoma:         "1060e7f022dfecad1e723a8c17c37d252a95ac9de1092d5fa8f2c462c625e3e3"
    sha256 cellar: :any_skip_relocation, ventura:        "722ed4cef8ecd284564e8f0313a174c07a03d3a7125be63f7096327a83092252"
    sha256 cellar: :any_skip_relocation, monterey:       "1c72a49ffa699a72d70b610a88c2eac94d99adb068efd02cd1484f7cec422ccc"
  end

  depends_on :macos
  depends_on xcode: "14.0"
  uses_from_macos "swift"

  resource "homebrew-testdata" do
    url "https://pub-0b56a3a43f5b4adc91c743afc384fe1a.r2.dev/SanityResults.xcresult.tar.gz"
    sha256 "e04a42a99dc05910aa31e6819016e5a481553d27d0dde121840f36fdb58e57b7"
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xchtmlreport"
  end

  test do
    resource("homebrew-testdata").stage("SanityResult.xcresult")
    # It will generate an index.html file
    system "#{bin}/xchtmlreport", "-r", "SanityResult.xcresult"
    assert_predicate testpath/"index.html", :exist?
  end
end