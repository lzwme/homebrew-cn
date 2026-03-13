class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.88.0.tar.gz"
  sha256 "dbecfa47f5f699a09ad5f426fa1833bdae2302455ba2b9ac5c9d1c61e737f4ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc657d98de9d2a4ac6827543a5871f7ac87dc4ad4eb932db24e1818bcb214420"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f79c548b26aa2738aa40450e69dae7befcb7c1862f6672497920cd334b0b3b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5695718a4396d300e8de940429f6c02e72e347eba4d2f2cddd6e9e4bff3a9558"
    sha256 cellar: :any_skip_relocation, sonoma:        "79305c6714dc74d2acea7124cde7a738a6e84f721dae79214049e2663ebd6d0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc7cc9bd759764055e0df2080dbbfef11b1228c7c8d97271bcce8dd1b86ab5e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbcbd81693c76d2211a4bdb043f2749464709af9260c76cd46e12712269416df"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(features: "system-alloc")
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end