class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.10.2.tar.gz"
  sha256 "6d18248a3902b10576cd01f30bb35668a4eaa4c28b935c2dad222f6ebb5465e5"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ec27ee91af2d4527dac455a2eaed065c2eced12775ec6b97fdf22a98ba8529c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8c91b6c088795c92392316bba346530e197632c638924c0e75bbbf4d673296"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "744db07c6147b781f087fc48a5e26491cae93e9ab6f6025e1b878e3dd020c80d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0fc34140fdf39302d5dee1c43b75a4ea27a7b41cd098a9966edb81cb8de551a"
    sha256 cellar: :any_skip_relocation, ventura:       "fd501bb050fd47bcdd958b2112e7e2201e211e3595b90e8f83bf668967289f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eae2dbde79bde24b0364dd46aafbb2e1d87b61847d4d1b26509cc0d55ccfc4c0"
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