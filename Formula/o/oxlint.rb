class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.10.3.tar.gz"
  sha256 "59d0093d4e2498bbf803bc2aafea22e3b170db7b07accb6efbfe1498fcadfddb"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b4555248ee51179b2dc0b941ec757d29dcc841c437f82f18829737a1201d120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeeb55dff219cd71b779fea8364e4875d4104e079628aec705fe9555ecd3579c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90effdc101f85aabdbcf4d1117411ab6c401b7471b69e3920610290bf11f9d2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5025105ff632a9af93c3eeb4cfb7f240b2aa331c6e1994d842626c0a7a962269"
    sha256 cellar: :any_skip_relocation, ventura:       "a4b02d3b5865944dfd8bd5c74248ea6c2a0938733b61d10e73901b90c6f092ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c73e4af2fca57e7ca8938ba46841d4fb34f7ad694974241fb228e8fc1b62fe4"
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