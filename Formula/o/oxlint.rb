class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v1.2.0.tar.gz"
  sha256 "0625ba7fae24d11b534bdeb612f3d23402d201cc7e6537e4e6242b7acd24d726"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01573d2dce3e12de45b105c8fb43b639a699c263f8e9b5d593f33d6023940f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03e27b8fb529cf8100dee714fd652a248fce2093565fb8b03406df1a8822bd00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5618470842f94a407535476742cb672a82642d0d230f89545cd2e2104c781d41"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a03ccf73235f1f59edcb13624e4a2b14cde52e1ab946348f49b7d518d34bbd7"
    sha256 cellar: :any_skip_relocation, ventura:       "c1689d7fbf010d6fafd91e936afa9b074a245d48d7c50aa90a25df1e51671bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5a18a8e9d5c4b0ac9b83bf5780ee3ad724f4853a1a53c5b30de6a96bb5d728f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a78d8d0d3b6be1dc33d8aa0283bc1fafe62f566308a9736d77ccdc97950820f"
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