class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.16.2.tar.gz"
  sha256 "b419c905bab19f5b14fd6055f1f75f29124d78e33b18c809df27cc14ad6ca860"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0c4a7221532d2035bb1f25a525472b4c370868e5103b779f7cd9475395b8ddb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d2ad9e0a702152c8d5f31d8264d98b905d14c574482dca9876214db3bbf013b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3baa0e3de9129700cb386b28ddea6e48a387b263a83e10f649278d780d58708c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1bb396282f2fa3ea692b083478b4aaff6e63f86ea8a552bb30da718558ccf0f"
    sha256 cellar: :any_skip_relocation, ventura:       "0ec8608caf8d624299fea60d294551a38bbe855e2634c4f394c53d59dc8d751d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bee3562d49494fa12f24b651d0cb4157d0f44975f0b8215a2d57a65b6f0bfbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b934bf4cff82f2580c93aab3639adbfa52208e6ab21aa403d7e0a12c93aa3c79"
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