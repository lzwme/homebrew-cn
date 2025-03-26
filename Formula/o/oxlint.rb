class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.16.3.tar.gz"
  sha256 "cc4f4cd322716de68664f6a1345ae951c027e9bd0b50f6107c2a6c4194c080e6"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "380720bfddbac24c1694e85e5b8a876e33b4e7e152827d82da619cb737612dc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b60a867f5ef7cbb37cb07a3846bde6f940d0a0b0590afb20e3c0eb9c01dfc6ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cb3fde0b7140b60b7200673121df1512a6a56c172c10b1d9cfcc8c0daa9c697"
    sha256 cellar: :any_skip_relocation, sonoma:        "2206466c8668fd674f7d70f0d3aebd7115ddaa6db150d8498ab50a0d226b3e2e"
    sha256 cellar: :any_skip_relocation, ventura:       "070ff2ab13e07d5a3f28d17559fa1fabb19e5055e9ef1cf346b17a42111ec286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84b31696bfb78e1d21d69a05443967e95255cfded7ac7050323912d74e453fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30afb136ff4f7ad330778c53b760d39b842b7f4a40b7b6cc6cf9c7fa29677cfc"
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