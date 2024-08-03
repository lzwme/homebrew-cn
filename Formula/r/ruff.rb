class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.5.6.tar.gz"
  sha256 "f774651e684e21f155b43e6738336f2eb53b44cd42444e72a73ee6eb1f6ee079"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cb985e0d5f8b7fae7df7dcfc401e8f06a009a84108866cdc3febd888ba3a82d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64f9d36edf6b1ea7952e03ae15a582f9762d93ca68e5fb3158f123c1aa897d14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba43ef9611c57f4273e7847b6004d189cdd8fa778d3c09ea298f47ca870b2460"
    sha256 cellar: :any_skip_relocation, sonoma:         "c378d3f2c488d1ffbcf3bd02c9e81b1f1a233a833ee1069c13c46d1e559bb47f"
    sha256 cellar: :any_skip_relocation, ventura:        "79e305364d6fb22a041e9858290891d02f0cab73fa2addd4f17506bc35cae90b"
    sha256 cellar: :any_skip_relocation, monterey:       "1da551ad27995f159ce8b685771cace86d8ac507c4bccbb3ddcd9fca3b232abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7aebe1555f39ee70c9ddccb8772dae0e775970176c813f342346dc536ed6c01"
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