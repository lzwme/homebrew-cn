class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "2464256fafa5f7f5d6eea43e7390f991c56262a65d87b036c98d66021defd97a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16ed162ade001465a55bef568c386d413f88a7b80a07daa79f31dc1de5f78c40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "709813c327ec78874d6c921a3bca0f6ce6d95c825ec08b549a207cd59a380ef8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d655de19cac8ba56e488dfcaada02d8631c4d4d461dc0bbe2399792cc108034"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4ba02414b34dd3d6ebe065a4dc7e76fd21c10ba8d862ba8a6bb511ba85191f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8c3ecfd8493f1a4e57cae3fef24f5d687899dce9a1598acdb6e49eb728266cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0051c61d54be0f42ffe38d510a96221c27b9202179e1c319047c2bbbc736dc8e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end