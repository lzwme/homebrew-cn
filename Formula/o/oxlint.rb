class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.15.tar.gz"
  sha256 "5b429c9e0923c05452b6154a1bff5fa3d047fc75d3ccfb57d2699ad432ab7019"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344add159ba9ec7f1f193a8b58a91867f6e0c94db11243915fdd98ad282098d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "253873161dda08a90ff075a3209924d966e38d55e97318f685dc73947107fe1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e53bda99308a320ac50b766ad23a48d928745d75b80b0e69716a34ab358ee9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b35fc0ee14ebd291e5159270515bf28beb84f2c4a3838ebfaf041c1856fb775f"
    sha256 cellar: :any_skip_relocation, ventura:       "fa9f11ac6c66733c79a2308c33f20039be75a39fd842cd535b8bc7e40168c1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "659815a0bc88e093667f87b6693f79d3e139273cfe7f0c0b7b54c340ea84264d"
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