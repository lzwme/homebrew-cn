class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.11.13.tar.gz"
  sha256 "fa786bc2ae0afe53571ccc7f45df0d901731ae2fa8b1ac3ff33241ada9874a75"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af245fa75e719e275d2ca4a45c41dc58124f94ece31a1b25cff7257657fd7cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e7f18aaef056804bb5e9790d23bb76e0ee73edb9edafc78f51e18ddf16df60c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6d96b9a1fc71b8dc5c95434282e615bdc05d2ac513a0a842dc6a5167ee559fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c174024f7332cf192eefdff2655db5a3d32084056d41e278c5214c6895fecf0"
    sha256 cellar: :any_skip_relocation, ventura:       "0f26592b863061bc2b3b157886b2203af6c5bbfaa22e16052432a06e7a5c9d43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06ff09e3c21f676c39a8919945cbdc6c142668cee1c8693f736956824ac37942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1fc80a76b6dac0e1825c3cc80a0efcef8685424508d4f1320ff087343afd500"
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