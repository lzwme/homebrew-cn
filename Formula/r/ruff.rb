class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.5.3.tar.gz"
  sha256 "7d3e1d6405a5c0e9bf13b947b80327ba7330f010060aaba514feecfd6d585251"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7ba9802a31e651ac9ca286d24898610889b94c31b773e6b2f70235438501a84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b77086536d9cd582e793ab253cee3ff1f58fdbe08adb5e44cca55fd66d777fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "318b5919a3db7d424fcf962ae0fc5fcbad6aedd864a9ea79276856971241f92a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1b0297a1325f31e02395145e500dee5f6dcaee0ea4bbd1e2a587f394e75db37"
    sha256 cellar: :any_skip_relocation, ventura:        "b33ad225af62be5874f7212843fabf9b16879d42e9524d78a88b90ee1695e525"
    sha256 cellar: :any_skip_relocation, monterey:       "a3fa42932352954c4bc18a09f0f5a720a618b543ec9a366530b9350a6293f979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d2e053e0dd54e3ac379766e928f4c1965df021a87254c1417b92fd6bb60ddb"
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