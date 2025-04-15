class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https:oxc.rs"
  url "https:github.comoxc-projectoxcarchiverefstagsoxlint_v0.16.6.tar.gz"
  sha256 "e4ac85bc975a700df742840e95c84d8032c656bf50400d0b83297b6b4cd6ce84"
  license "MIT"
  head "https:github.comoxc-projectoxc.git", branch: "main"

  livecheck do
    url :stable
    regex(^oxlint[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4160f235edd117b99191a726bfec0da2de042fcd3970f5fff889d5d79c259e96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "512ad4412b4acfc56e08c3a814a770393d3f2a9e14efc5743ebdf631c7c403e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0149a29e3b594ae1aef85b1c55c1a97cb9ec5cd5e49801ce2f0b5e20e007aba"
    sha256 cellar: :any_skip_relocation, sonoma:        "a71f910308a94386d1a28d917778ceb2bcc3293470a8fc09d74d4c4dc2fb16f8"
    sha256 cellar: :any_skip_relocation, ventura:       "67b4c142468fc23debcfe7f272e845c3ed854c1611dd7d87691a333b008779ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb793f80738f74b03c839b0e4e85c7cfbf1486222b14557cfa362b0bd617ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2d6087aa85c1b8153f764733576bdc4dfa02478a7cfcff3e9cc1ea9efae19d6"
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