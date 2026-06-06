class Forgecode < Formula
  desc "AI-enhanced terminal development environment"
  homepage "https://forgecode.dev/"
  url "https://ghfast.top/https://github.com/tailcallhq/forgecode/archive/refs/tags/v2.13.5.tar.gz"
  sha256 "66bf3b4280f21514e10b11020c7cdccd3e04e96694324b72db3e199d81eca1b7"
  license "Apache-2.0"
  head "https://github.com/tailcallhq/forgecode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74ebd5434e9b8047d67d022e3e3dcf12c8c8f539220b53c8122e0581bf8097c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fa8619d2ad5a5c5d2dbc411df77f88923177a734fe1fdc2b8a732a2cd48ff8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aa6e3f3810a6ac68ca245393f312b3a133b28f9b1862ae0aa3047686ea733a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "241a5b4b3a3cef2e6e3d9eada4835ffb8d27740745e00fc7372d6477c0a0eae7"
    sha256 cellar: :any,                 arm64_linux:   "f6a0b7c36db94607be72c38675ec4e12411ad27b5183607277fc3a473e0f17bd"
    sha256 cellar: :any,                 x86_64_linux:  "7e77cf6e8fd8b67150ec60f2800147785d4f3e7f91cd809c778c305ab6b8b39b"
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