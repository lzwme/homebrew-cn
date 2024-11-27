class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.13.2.tar.gz"
  sha256 "312508649dacba3449645bbaf5b6cea5f7bcb5461e25e7d382e7d1eb143d5798"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4a8990becf590e3074ea95e1be7d12fc6b04bf954174cd8ea106365a2bab21b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0a773b7a33eb52f37ca7fafd10f48860518c4d4d2e62cf2e16ee299ae3fa40f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a718264ddd69d93381c201c169eecf234fc909e04b255feae1df2ec67e39171"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ccade982d59aca813d12e93944f659f255ba168fa69a0f8bcbd37c44d06521f"
    sha256 cellar: :any_skip_relocation, ventura:       "2033957c45d89f33a2a8cda341cb379f003fb8c1baa91992f854903cc9969a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b1da3d23c44f2694bba3be990b63ef02075a0db610c06fa590cf91315226bbc"
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