class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.4.tar.gz"
  sha256 "be70d4b2963bd1603bc1ffdab9eff6a40f503b6fd5ca3d5e7ce32c15a101942e"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af34eaddfab9791a339ec794f29b86973a3668acb079c164ed95809066c15f48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36c67e7b51714003e24ac782e0cd1980ab6582d8303727a830a370f5c97d3f8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24c4e8b4624e8b3fb0df719ae1a0e62a3da535277f779f85dd6fedfe7609de68"
    sha256 cellar: :any_skip_relocation, sonoma:        "68c0e2017d7215b2d70127fb68409da499ddd8b56378ff483c4a970d99a97e23"
    sha256 cellar: :any_skip_relocation, ventura:       "af9650dd40d345e8453a49db25fae1f2c4b50cc2738f294ffab6279513cc1f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78956b175ce01df635a8336e9b58c665de09f3a817b14d7cba5bb1f559dc6cb7"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "appsoxlint")
  end

  test do
    (testpath"test.js").write "const x = 1;"
    output = shell_output("#{bin}oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}oxlint --version")
  end
end