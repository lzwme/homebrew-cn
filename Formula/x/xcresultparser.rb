class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://ghfast.top/https://github.com/a7ex/xcresultparser/archive/refs/tags/1.8.5.tar.gz"
  sha256 "47011cd0bb3ad217780274555af50fe38f03d8e9deb4fe03ed7a3c1e782deb59"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f576f5ba61ce21d8c490d01e126cd7045e48b12cd5005ffde8ddea8c0404dce8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33724a00acf49733e806f2e06d3eb89e2722b5ea8a0ef37a1d8a2b1d58961681"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98e359f359c24fe7d24a426062239319b704fc1b4544ae19a1af8ed929527487"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a6d02101985dd1c5b8637230b49ab3d61bbe0042806690269913440b61ca854"
    sha256 cellar: :any_skip_relocation, ventura:       "0e2890e6c73bfb7fbd301d34f1aab277deddd785afed12933e4168f1e3d3d154"
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