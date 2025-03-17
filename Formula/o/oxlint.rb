class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.16.0.tar.gz"
  sha256 "ad48ece3f00659d035b8a4b940775de289a4baa350a1c754bec710129c23a1a1"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e82067ecee79e486a96852690ab1eea7d8092eb4f3a7890cd4f742d8dde4df80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72698107e1b4619dd609fcad42257b144eddd3aa82ef93685a2a986b015f2a96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "029b700af6bda5f10a879e85e0ff591d0a489c036a59fc2fb4f72f983039ad7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7317650fc49302de30cdb4d6a23da77c6292e2992f9eed88fa87b99e683b1460"
    sha256 cellar: :any_skip_relocation, ventura:       "16accfc8667ba189d07c72e9a89b6ac781b3cecb16bdc6ae04f67a52b7b7f124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93fc6eb73d8a0f5fd633bcfb9a13cd2fcbb11053e483aa4b39fce276729fe106"
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