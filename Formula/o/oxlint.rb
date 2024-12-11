class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.0.tar.gz"
  sha256 "028ea15c7a5372d246802f072e22de111588def5c6e5d9e57615b10f18926077"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d53af3233e50ae6f1d4cc7f0d6df0d58c49ac0c4a2bf10f180b569f1747416bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22d4fba7c99686092a0380f04e1869823bd2a7a1743ea7a098c168d9baccb522"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c9e6c717081460e76b1e1befbb5797a897f514836e97b9dce211b7fbeb04b83"
    sha256 cellar: :any_skip_relocation, sonoma:        "84057f23c7f01c3e2c65d1c1d46500d7aea1f297d502a7450438d6037e1c8042"
    sha256 cellar: :any_skip_relocation, ventura:       "99f568cb3a3e40daf2947f46d3af97a0bc736082ad6a38633b287ad2361057bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ffdb03873a3b66c55487116b879e56ce1070825962f06873e25ae0320d3a764"
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