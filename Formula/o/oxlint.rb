class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.8.tar.gz"
  sha256 "c163f2430ba0dc5ac5c321d49f88265cb0659db222e55d1decac24fc4db47938"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a03c634fd1c992ce4cbf29e71cf5d88c355b69574eb62eba7756c00521f90b19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b745cce8d9023a0cf767dcfc21ea66eb3a28bd6bc26d43ac1d5cb2917b86a587"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e5a91964b0edff10bc11c3329e466ccf53ac9617cf4d2d83c144428d2ae9b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "59545832bacc50348c3eb276aba752e0157ea90d441abc543e6a0beca91f479e"
    sha256 cellar: :any_skip_relocation, ventura:       "7dbb7bef1ebd5de25640c7165fb9a29b41715260bd4af28b582e8c079bd23073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83ec9662b454f9d504309dfe072831a8657e46715bcd4ede40c0a7b37c4ec2a3"
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