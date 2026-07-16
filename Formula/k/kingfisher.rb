class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.107.0.tar.gz"
  sha256 "11954216a44bf909fdc4711fbc053a5111d1287b87497ea4c89e28608b50eb02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01b300388aabf221f590a00a5dc46be863649d0436439d4a6c9cbadc4760e47d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e60d882ff0c49d7c26d1b03bfab2b45fb5b0866db67d835d59f42f5568d3ad9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f826a255f2bf5b9dfd350fd7e38f6d6faf38e8b64453e0e1acfd1b9ec2721459"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2f3f530b4b73caf81b9579837b99b15076e1fbe30cbbbc3e40958d107f2aa58"
    sha256 cellar: :any,                 arm64_linux:   "12ea81c969a61fb6068a4fd63ebe284525d0324ac74248497134f8ab9f5a96a6"
    sha256 cellar: :any,                 x86_64_linux:  "065f7eaecb9f96f1cef6fa292b652d8f5050728a3ecef1c389f88689e2e0a864"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end