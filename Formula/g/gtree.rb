class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://ghfast.top/https://github.com/ddddddO/gtree/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "e35358895bbd2f2fa88318a7c52c93b8fb61685f0314422632ac8a7946fbb01c"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61adf729ca9ffa0e702fb50a948dcc7ca9269e21a91504227d60bcd56e964d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61adf729ca9ffa0e702fb50a948dcc7ca9269e21a91504227d60bcd56e964d15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61adf729ca9ffa0e702fb50a948dcc7ca9269e21a91504227d60bcd56e964d15"
    sha256 cellar: :any_skip_relocation, sonoma:        "434afc4e9d253b88e5e69ec4b9f1723ee1ef2f577f69a08c0d144c4a0b29caa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1062e5ebfd977b3281e0e6b23f77abf6a493e60b72ec9ca9dfcf26fc015abfff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "161a7e8d7c7050251e93f89430da6a07dc548c08c0cdc11ebca3621ce027b967"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end