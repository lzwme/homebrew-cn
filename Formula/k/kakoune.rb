class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://ghfast.top/https://github.com/mawww/kakoune/releases/download/v2026.05.21/kakoune-2026.05.21.tar.bz2"
  sha256 "be1deb3fe9808a0733ab1057309da380bb757307e8fdbb22dc478b674b6bad34"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d375c58634657d49ffc5543574588b5d7ce8bda921cc291d61d3884b770fc33a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e83a79da9f216318348230b255ecf9421f03a043e919306fb8a94c7183ee3137"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5e8ad502f2b63af404a27855b597bb35e17d7911ba10017f833267014e5f3e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f86ddc70a29bb35c9879cee744a515eb47bd7d71952578ba581e0d75b088bdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dddb947e2720d0ddb250ecd6e9454b89f76a53f60b64825c84c32b1fe1105f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2735ec518c0e6ffe6fdb89f2981e7e4f9f19c2fd50b35c404611220cdd42b10e"
  end

  on_catalina :or_older do
    depends_on "llvm" => :build
  end

  on_linux do
    depends_on "binutils" => :build
  end

  fails_with :clang do
    build 1200
    cause "Requires C++20"
  end

  # See <https://github.com/mawww/kakoune/blob/v2022.10.31/README.asciidoc#building>
  fails_with :gcc do
    version "10.2"
    cause "Requires GCC >= 10.3"
  end

  # Fix to error: no matching function for call to ‘lower_bound`
  # PR ref: https://github.com/mawww/kakoune/pull/5472
  patch do
    url "https://github.com/mawww/kakoune/commit/9d5fb1992e0149130706aa6c9cb3ab474c580597.patch?full_index=1"
    sha256 "3b777df6d6773daeb23cd5fc59a8732fcfbb62294b37c1108ba7e3d8da9524d1"
  end

  def install
    system "make", "install", "debug=no", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"

    assert_match version.to_s, shell_output("#{bin}/kak -version")
  end
end