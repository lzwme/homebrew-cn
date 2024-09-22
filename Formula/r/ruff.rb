class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.6.7.tar.gz"
  sha256 "9539e7f928c42fb77ec6b52f4527f3837d263d250f9659a0d8e1d378f38bbfc8"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b121c954f886297856020461e233b715b8219e54dabe7b9d0901558ddcf963"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c0a2302d4f66d59859af2cf18f23ed0ac3e97f4c935f8242f03988c7ebf65be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dc75e5c05762f7c2e202932175aa8156e113445321dfeb9e26a19e27f3248fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "823019934694df716909b513d7a4bbb46f779e9b0adcbf1b4d283ccc33ad391f"
    sha256 cellar: :any_skip_relocation, ventura:       "fc4e30faea2e3d95faf29d8edbca1b0c9c1bc9f3c0e8dd1f13e1192d1ef438da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8571667ea375cd4db6968f2db47eec308a9bb99c9a33936b444869ac60b7fa8c"
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