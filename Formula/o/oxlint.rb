class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.16.11.tar.gz"
  sha256 "ce08a1a03d7722109e82964e8a4d96f7b233640c902597f83c02c9133b629779"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ff4c563fa80ee3443f242bce28e5d01cc0f7615316d2883a1048a67b8aa19a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f1a397d8597d2374187faabdbf27880e76bd0ae9f910eb6a7479cf1a5d37412"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9314f5ffbe22b11cf85f952771efbab569c58f57a141c1e86b6b0d92a523e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "7408e395625981a376ba9dbccf8917dc62362487042d421d1b52ce4c5aee6cbe"
    sha256 cellar: :any_skip_relocation, ventura:       "284543454c537306de5879e818a157e28d33a6e1b24318846cc1c1768898a00e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cb3b4fb77376dda7cf7cc7b8ac382a4274d064e39c3ce08088f71147e766724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d5161f2e774ad76f91a666fdc3e2c9d0bfa56b241ea0f9708e0c29c6fdba8f8"
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