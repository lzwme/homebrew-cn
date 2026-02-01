class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://ghfast.top/https://github.com/ddddddO/gtree/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "08caaa8340d565482da00a4b985be66a744216b0c16ca92ffa68d13f50271752"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7596ffb33074bb609b87f0afc4de7f8b6b25f1eb7f8c6225fd8b969ee0a6bbb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7596ffb33074bb609b87f0afc4de7f8b6b25f1eb7f8c6225fd8b969ee0a6bbb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7596ffb33074bb609b87f0afc4de7f8b6b25f1eb7f8c6225fd8b969ee0a6bbb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fab18c77843e300035bbe57210b41ea38b97ff6cc94125f08161e89d2340a44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02d0b1ec759601a80dca8730d531b2046bae8cb22311515d347d17e5031ff600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5acbb6505fa9ff0753225c732d64ded50624d79fbfed18f052efd8746309f96e"
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