class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.6.3.tar.gz"
  sha256 "e19b90c85f8d0cd1395429eee748bdf8bc95e2165018fe12f0331307e4d1689b"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fe0240f0b665dc57d9bbed05e62c6205d84710e1d2c5b0cddf0b9118b4927d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0fd3d7926dd57b4e191cac63724060902b8ff2bc4749a7853b85c8d7cc100db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2767cf41f8ffabd877d5715218a669d7d694c63f5c00f66fdabe659815fb3422"
    sha256 cellar: :any_skip_relocation, sonoma:         "d18f07cd389a8bfd4aaf4677ea709bf89ec9fa886819d5c0a9d6eb7026e69f88"
    sha256 cellar: :any_skip_relocation, ventura:        "7a307ca1cc34abb988b4c2f58907ab3e773a7209c4d5f02d9f3fa9d7be9ea043"
    sha256 cellar: :any_skip_relocation, monterey:       "a96b07f2c16be3f6ede7c1004c56c1415c188b2a6ae2d5e2c8189cd96a1b4a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c12a809a10356d5c53153ea07c287a786451885dddea882d1835e435f864ab"
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