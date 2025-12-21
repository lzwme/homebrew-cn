class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://ghfast.top/https://github.com/benjajaja/mdfried/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "e0e4001940e4cb2d6339963338bd1326772542c697f910fe330622b8b9990994"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a415c313c749e8b8e4d56c555164d78aa033abbc078981e75ce56aa28ba5ac64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fe30c751df414e82a98f947ca8870bfe0172ff93ab0048eab0cbeb2dab31a4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10f2f8103d3934b3955a1876dd42a4f78f3e3f301234e5cc27a262284b1d56ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "751fda53f9ce2e9b89611b941591e64a48453e7e6f3498bba69288753af1aa47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8396681f72df38eec8d8d1c2c138258a98e52161651c6926dd862f1d2be6b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02c7f41f20322450fd6b2af36ee9fd7845fda4b047be1527ca34fe5f1813b117"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output = shell_output("#{bin}/mdfried #{testpath}/test.md 2>&1")
    assert_match "cursor position could not be read", output
  end
end