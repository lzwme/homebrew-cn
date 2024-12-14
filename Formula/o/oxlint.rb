class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.15.1.tar.gz"
  sha256 "44aebcf84e4ea5fc25c603d82842b690fb6c8db4b968b943533541a1273397f5"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aeb57bfdd65b7c93220e0120675913516bd26285cead0b8da44e9dac2eef297"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98628072ea860d840df00399e95e82b7dc28e3e637a7c7ec53348fefdf2c1669"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78a7117c69a5ba8df103d0646a5ff8ebc1d4ca935c213cb4899aa7f6df31e79b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cee99f4c670f5c574f73b53583711dc3ae13d5f124a5776ebbfe5d78c8452d73"
    sha256 cellar: :any_skip_relocation, ventura:       "3b62d4a008047c5c305266ff40203024c4979fb91c8939c8d2473bf59b60176b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf60a4ee0b1adda49906268e138d59be2068c49eb4d432519214637dae4361ca"
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