class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.14.tar.gz"
  sha256 "3288f9f3d5b839896bcd3f981d94d78aabe690e79cef50c4b1a46f36f277ab6f"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d1253edc764c5ca24301bb097453e3784236d224cc2fc8beabb2047cea37d2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27b602ddbd8496f19b662151977490c4ef000ccdd472d8d038cfe0c33263d618"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d73feded5cb5da68561a5dc97304066bff878e03a71d13b5802e3642e14ecd92"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d76bcdf9d64af98746f32752727d3108bac5932b58cf794efa39409baa9e413"
    sha256 cellar: :any_skip_relocation, ventura:       "ac2c5bb453cbe8ca2e1481e4461f797d14f356a55f20df9db675ce150b486aa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c72c19f749d55b41e856ba1db8f076edce90dde2141633e819b09e745481e5c9"
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