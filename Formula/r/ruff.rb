class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.5.2.tar.gz"
  sha256 "3cf0ada76f6b47dc4b2781db295bea25ed89deb178bfb73b0ed77543c486ca29"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b66579fe92b173018f34ba85c307daf9f17c310c795efb03c561c5c035666c49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3473f65f38c118f1ead470306171c99c6e412359d0907ee9209a3fa9ce9e4df7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "112c33e963b5308c68026dda51b29f6f02cb93d24fac6e6ab642bbc0a146cd00"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ab6ff3826586a02ab65fd1dfa33503961241598f4f95a2398164abd84d7a771"
    sha256 cellar: :any_skip_relocation, ventura:        "82b2fbb7f88af803b2a782a5fb91d637eef1b82a17eb795ac5525c4cc8d87410"
    sha256 cellar: :any_skip_relocation, monterey:       "2eb834374c0a155e5d031202d95e62a5197fa3001d8421b1a6f5b4b89802980c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e0e45947e74b4119e09f17659cf832273d598c4b5171ff09bcea3b61bac4274"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesruff")
    generate_completions_from_executable(bin"ruff", "generate-shell-completion")
  end

  test do
    (testpath"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}ruff check #{testpath}test.py", 1)
  end
end