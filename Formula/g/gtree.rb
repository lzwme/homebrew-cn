class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://ghfast.top/https://github.com/ddddddO/gtree/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "043a7766f81e855f8883c39098aec3d5e9cfa58ee9022503ecaead686adf38c6"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "615fb48889bf535199e569ba234f39a9d0071c178e4eee044a0affd092520bb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "615fb48889bf535199e569ba234f39a9d0071c178e4eee044a0affd092520bb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "615fb48889bf535199e569ba234f39a9d0071c178e4eee044a0affd092520bb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c8d534f5b667792249bd5f4863ce6eaf44a64ce431df7f96e95576f7a6a4cea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13f256abf13e0441d81329bae0a600c15a5690f768d30d2cd6f6580320e3d662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6312c03b7276f5d46f5a5639eeaa66ad04dec587ca720059415c1794be093c65"
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