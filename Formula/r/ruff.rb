class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.8.5.tar.gz"
  sha256 "27d3ed3b4f9d7a221326be40c30837137cc11b47b187ffeec979dfec9cfd1d3a"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a98e1fbcb99f0e890020ae68027ca968f94fd5924c724c36c0a8eb6d9ca170a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c971b3b4eda7875dce260c8997ff1e8fef203510625c4c1fb31124883c5b2ac2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4199eb7de53af9412036f08ddc5d74883f4397c96c2ccd637aa9bd849d86efe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "682a7cef30a0e2c1bd344d0f748408ae357169eb5635187b45e13567c3994bd1"
    sha256 cellar: :any_skip_relocation, ventura:       "25b263f5b5cc50d5c57bf948e72584b684d1e592c98a18010cff0f60202e4c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07f40071faa98565490b532040f182ff66ca20f0048b884518ca5fe96233b96b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cratesruff")
    generate_completions_from_executable(bin"ruff", "generate-shell-completion")
  end

  test do
    (testpath"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}ruff check #{testpath}test.py", 1)
  end
end