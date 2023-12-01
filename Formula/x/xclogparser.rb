class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://ghproxy.com/https://github.com/MobileNativeFoundation/XCLogParser/archive/refs/tags/v0.2.37.tar.gz"
  sha256 "4963287d3326ba72f612cce47bca7ce1aaf95e00fb3208cba8cbd19a3eb5b5f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffa01e5c992406ba6ea5630304ceffce4ff4510cafa91b949414b3727ba4ad0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86e09c6a4186cd8d4a6da1c065d04af23fc44a9654bc3c6218fbe3689d702806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef4ffa19b075181856b606263feb0bd6c31248a31bc41c99b1c5f96d4fb4f71d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b3cc6427f457ff47c04b93ff9598ead4ea4f1a67b0a3f8f28900b83809702d7"
    sha256 cellar: :any_skip_relocation, ventura:        "e701642487db288d3b943dcf997458bba44beff5c1ca22c05cf25d16fc19ff57"
    sha256 cellar: :any_skip_relocation, monterey:       "587d8bb0db377eefd3d5c414d13be4899ac7d22f843fbdacb4ed93740d1990fd"
    sha256                               x86_64_linux:   "f59b267b9d870cdc1926e4e326c4902bbd8431444e35d642d32a700dff8dd3f6"
  end

  depends_on xcode: "13.0"

  uses_from_macos "swift"

  resource "test_log" do
    url "https://ghproxy.com/https://github.com/tinder-maxwellelliott/XCLogParser/releases/download/0.2.9/test.xcactivitylog"
    sha256 "bfcad64404f86340b13524362c1b71ef8ac906ba230bdf074514b96475dd5dca"
  end

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/xclogparser"
  end

  test do
    resource("test_log").stage(testpath)
    shell_output = shell_output("#{bin}/xclogparser dump --file #{testpath}/test.xcactivitylog")
    match_data = shell_output.match(/"title" : "(Run custom shell script 'Run Script')"/)
    assert_equal "Run custom shell script 'Run Script'", match_data[1]
  end
end