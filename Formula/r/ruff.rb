class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.6.2.tar.gz"
  sha256 "5aa788770ad1e11dc11a5a3b7a75a3c5452ba4e2f812a03fb6a28536032b4853"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "998f302f1ffa28157b357fa147247a74e1bd380b2f4b820fd56cdc1a3185c481"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39518da96e61240bc135d77f1f0abd793bfb9633e2d985b20c540352d06bc4db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08491112628aa364ddafe8d02099a8f21bfd1b9cc3af328b33eaad13524ac85a"
    sha256 cellar: :any_skip_relocation, sonoma:         "274a5b508432e5b4498696c9598d24a4e6b24e6faef66a6650b147207c828a18"
    sha256 cellar: :any_skip_relocation, ventura:        "97df73c2988f5c2c106dd3d2e059544f496b6f059a0f194fc11b896ebfa6601f"
    sha256 cellar: :any_skip_relocation, monterey:       "c8438b32fdf3d0d408d057ab5d113260a6be2f8b7e9e4aede05f48797bd14733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7263ca20da41e48b8f5e39ffca998b77461287c384d106afeed6970aed1cd5a8"
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