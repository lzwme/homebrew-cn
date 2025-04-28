class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.16.8.tar.gz"
  sha256 "49b1db1df4a0586f59e11fd4d6bebbdd1319fc289213e949e5cb9d5e1555ba94"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ef53d1d9dbad95264333a747826ba3f3fea2489a8f2d7d559ad4ea3e38405b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "683234fb87c3f63ca57aa384c335f2a1472fb2fd5415c71e5dcddfe5cced4c90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61afef2a6d99347e7ea530593f503eae21c8ab9ca10d8a8094e9e364f3e83cde"
    sha256 cellar: :any_skip_relocation, sonoma:        "447866e2b04637c3d4a140fa271784cbdab947a02e3a0b7b3d1e1a506b2fccc8"
    sha256 cellar: :any_skip_relocation, ventura:       "09887ef2f0d4337985ffa87db80c7699f2c643925417c0bc9fcf4859a648c466"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e9efbafdd1e7789a9aea311fc3e81b4b5e5c7fd2ec67326d8afcf62f661992c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18e795356adfd1e9cf855336e104ae311bb19d0568dba1698738dbfc2bc64267"
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