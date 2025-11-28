class Gitlogue < Formula
  desc "Cinematic Git commit replay tool"
  homepage "https://github.com/unhappychoice/gitlogue"
  url "https://ghfast.top/https://github.com/unhappychoice/gitlogue/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "0e1733b19f8e7c43ef7051a92a3c6518bbb56ab6b42ed30a82b7c068e469d02f"
  license "ISC"
  head "https://github.com/unhappychoice/gitlogue.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "055614d8ea1ff0fcebf6b1f6e325ae379547c205ac48df025315a8ca5be2b939"
    sha256 cellar: :any,                 arm64_sequoia: "bc3dfab7e5bd9b569c55cc7131b3e00a47f3471c90efd04278a9804f1292f391"
    sha256 cellar: :any,                 arm64_sonoma:  "4efa297484198920e972343096a2688aaa1fb3a2365dcd4f73a530b7961883a9"
    sha256 cellar: :any,                 sonoma:        "9b90fc6ab8f2aa663cd007e64ad07cbe77ff317cd546f46347e61e7cb69ff65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "405ed62df60a3c3b09e949021135907c9a88bceb5cc3acd99d8571806860efb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "587eb12be72682b9dcdfefe54ece2e9bf6368f6652898ed48ef2b84a67edc455"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlogue --version")

    assert_match "Error: Not a Git repository", shell_output("#{bin}/gitlogue 2>&1", 1)
  end
end