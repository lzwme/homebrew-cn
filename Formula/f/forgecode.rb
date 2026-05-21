class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.12.16.tar.gz"
  sha256 "fd1ca2db4abf0ed2090b6b2d7da7aade3c9eb762a0d839951eeb3b327f4e0724"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "915f307ef1f72103012c61cdc2798b03ec477626f4b9ef7161de448a65f09a82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "146d65fca3c997c03eacdeba78f5cf3bc594f8ab84d48aff9c2216d3f524e97a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eaba9772e5dde2ce27f73b76920e4f725229dd69a7b43411c11678efe0330ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "426ca82a61965e15d174873adab269ea9c226922b9b49ee237d7d63baec46fe6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0792adf37ef17bd554849dfa8e9c48d17ab5ceb0b63007bb6c74ac84dbd31e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a62001099f397e74757944818580d3a2107c34956cdfac1ed90d3b2ec923ca0e"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    ENV["APP_VERSION"] = version.to_s

    system "cargo", "install", *std_cargo_args(path: "crates/forge_main")
  end

  test do
    # forgecode is a TUI application
    assert_match version.to_s, shell_output("#{bin}/forge banner 2>&1")
  end
end