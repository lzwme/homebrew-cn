class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v1.0.0.tar.gz"
  sha256 "6cb6d2add948ef9a495b2c5caac0faed268413e1f88558bb62a3ccfdce0a75fa"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c662f312c988d44a7bd005c48665784ad8b5c0bb159010c58562c63badf915b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8411e66c3098c1f8939e66da5bba413d4c4cf35c6e75816fd0a00eb6684328b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2572e075f820566e739c4d7b7174af2a1367840063588c12e6bf0142fff47c64"
    sha256 cellar: :any_skip_relocation, sonoma:        "10437d4294ce46d694126b85aa58cf12231762b9702b8e745ebefa41840d8fa4"
    sha256 cellar: :any_skip_relocation, ventura:       "ac333eae5ee00a5cf0caaa8d139747c7612c6e6b5d8a63c925be7a8e38ad0baa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f4a796f2969c911f7015834b0e86ee62acf6b6f093b6282259a955243b18a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7433e43a3ad3296aceab55295cdad32b0c037df7daa4542cc5590bea89e2fb7a"
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