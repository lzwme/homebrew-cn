class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.93.0.tar.gz"
  sha256 "32fe5df07c5202160225dee78edc2d6efaf5e395d971a1e8f4940f3a964caccc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3e40322d4bccf5aac54969727a9ff2942e663cb83b961cf21d4114a86ebb125"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84285788047f8a3c988bc25bcd777ca56358fb70947de450dcf88df33ddcc334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f489947743bee4cf68b021a6da9485f98aa06758d2e57a066e76bede0d97f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba16a6df7db7f7a2df5a535ad8d16256ca58ef0db0fb5914ed64dfbbfddc26ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "279883bc74e9432b049e48ed782b5c0f00f35acc9ebaf714d8721de5ef72e859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79d809e8f7ef1eae952a9502c6c18307b402f611ed67bd14624e4a8a68c4c282"
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