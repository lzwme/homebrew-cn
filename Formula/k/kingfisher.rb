class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "ee353fa572d0015f99d07e88a81339aa9b60a5be99c38dd7c40435acfeb6311c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c1c641a3be19550a4d5371fbce46f3450530583aff11a58eceddfd18821c752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef55aec467ef85e33494209f6e0b1a8f60d362cb005bfc2eddd5619edee629f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d765dd87d71d71e22d51efc435d1ab6488a5d789d1aca6a826283c241d3d5b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fab6aecc3fb3a947d02f5a45c8e1e0d6e6fa5007fa3d0a69685603b4cbc89b94"
    sha256 cellar: :any_skip_relocation, ventura:       "93297a6848a70fe32c2b12ca97833a290ec516e50e8a0b596beeab807792887f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be9117156412a767a0891b86d7a33f1760963342f2a22725a408359ce8c2f7aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7519f673c7295c2ca38fe2b5ce4b7a33c768505d26e3b1a09ab90e50dccd7097"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end