class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://ghfast.top/https://github.com/a7ex/xcresultparser/archive/refs/tags/2.0.0.tar.gz"
  sha256 "c579a8937dffe24e00d0ac1f5275dd87d8dddd244c7df71db2bf64eaf1bf5ebf"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf4211645e39d8f0272644464bc5bbc1aa1c56ad54829d71c552973c44a7de5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfc9ac778b4dbae1c63ec8086608be2f13d681de2162248dcf6670f5d41b9fca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbdc99c3b400c1298f886c78b285cfa80c246b2dbeec9e436b792a65c7ff85cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "288e2bf184ad7a97442ecc068462631784730a960d3d37727642d64c282d40c4"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcresultparser"
    pkgshare.install "Tests/XcresultparserTests/TestAssets/test.xcresult"
    generate_completions_from_executable(bin/"xcresultparser", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcresultparser -v")

    cp_r pkgshare/"test.xcresult", testpath
    output = shell_output("#{bin}/xcresultparser --target-info #{testpath}/test.xcresult")
    assert_match "XcresultparserLib", output
    assert_match "XcresultparserTests", output
  end
end