class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.5.7.tar.gz"
  sha256 "7ac2fd49222dc31aac0f97a40ea5d1d74dee9a1228ff5d62d603359713d8e0d1"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0194060eb4dfc4699d5c2b055bd289d49ceaf029183849f9bd5b4c41992bcf28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3505eba45275833b76dc8270d42cf407f4dd7149ff08fd2f1a3aae3cd8ddfad0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee340c962d1cc8d5da2ceea3e5c1bfb686dcbf6e33f003e155130784c946e4b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5dc79fd78ed3d1f865036a0563d78b64b8d236a8af0e56bd0692b00c4f5f19aa"
    sha256 cellar: :any_skip_relocation, ventura:        "06f53cfba0ec7b8efbae268220b685b566163b8d6162a73e75f39cf65119dc56"
    sha256 cellar: :any_skip_relocation, monterey:       "fb5ae403f02cbe610f9b5050536bd0998257733211bdd987ab53f53f6abdccbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "217abba7bbeabda5df172a50e0b77f3be2d893e1717602ccd400c72df929158b"
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