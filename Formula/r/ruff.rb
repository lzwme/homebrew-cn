class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.11.0.tar.gz"
  sha256 "506f828f24a7dde70d8683bac000e4d18e4bb14a4dbec7a42a42ea1b1b257386"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb4b191bad6654208bce504bc120a20da418fbdb4cd574de1357e0161bf4fd33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f055d8897e84d8be764d75d791c6268aaa91680db624e6ac72cc4f6e74bd633d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9efb048cdf0317577cc5e270feb0746001f27a770dbbd98b7b8b551a9e3abf43"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc7dcb1fdeed03f384010a95ccbf5e940acf8ecc3c170523ef1759d9c4ca2565"
    sha256 cellar: :any_skip_relocation, ventura:       "36892fc01d86694b3666d566192a87156cca7692e46ee689f6018b5089b82e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "226eae01d1ea0a119c8af586e3118194958e6749ed92718f560189c5bd6d0bb9"
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