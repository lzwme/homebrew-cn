class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.6.4.tar.gz"
  sha256 "4ecd4401021101db10f6fa5133abab5b20beb14e0be13ea3fc2fde574596f5bf"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31f056c007a4fedc49995251a97b7538e1fda9fbee024acc9981078c1853363c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7363ca1a1d89ffd186c52ffe96e1527cde525bbdf2d08fe3c83b55bc9d8f87a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb9cec3f25f5a5a41e56b5f292e9732b059a1231be0061edbbba7990eb6199cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e8fdc284d0c166d874208bce4a54171d0f7df4d9f613e587d740ff589940b99"
    sha256 cellar: :any_skip_relocation, ventura:        "f81aaca0e5c979f2f8a4097e15266f033fb9fa6742c731292723879db7ad556f"
    sha256 cellar: :any_skip_relocation, monterey:       "1802f337c052eac55cfe77d715f271e45e6272c34c57c1db19767c718a8bf90c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef8b2e388b04295df347a0d492710e93718473ea4f6f0b0c81382adb6be03038"
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