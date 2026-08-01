class FancyCat < Formula
  desc "PDF reader for terminal emulators using the Kitty image protocol"
  homepage "https://github.com/freref/fancy-cat"
  url "https://ghfast.top/https://github.com/freref/fancy-cat/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "c40cd59bef243b3bafa80a33ac97d07c54ab27490d13702abeccbd713f59e37c"
  license "AGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cec4aa626fd5193d762b9f4c189be54bac30fd0a0ddcd13ba793fb2ac8d5dbf0"
    sha256 cellar: :any, arm64_sequoia: "0a6f00def3e443314ebe0232d61b53d6e79b649aa2e23248c3a9c84bfb18460b"
    sha256 cellar: :any, arm64_sonoma:  "1ffc4916fc271fc4e1d4dcf42ad3bc7ca5678a4a81a4cb9d4ee08f08bb386938"
    sha256 cellar: :any, sonoma:        "f19b5ed1f9851a5540a49eda8f71cc8cd5e73094bf5fab673ec3ffcd491c98d5"
    sha256 cellar: :any, arm64_linux:   "eef18fdf32bc3b8c248ca8f6d1fbfc058a693655df5212a16188cee396c789e8"
    sha256 cellar: :any, x86_64_linux:  "c057d0dfa2b9dec48b430aaf3e52414fec41a3e3764a30c2195518c1d9442e90"
  end

  depends_on "zig@0.15" => :build
  depends_on "mujs"
  depends_on "mupdf"

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    # fancy-cat is a TUI application
    assert_match version.to_s, shell_output("#{bin}/fancy-cat --version")
  end
end