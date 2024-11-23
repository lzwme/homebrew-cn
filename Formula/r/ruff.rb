class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.8.0.tar.gz"
  sha256 "d2c112522b978a5d8938a98c916f61d3f77553545dce116bded3b7156209a138"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5fcafbb3547c2a6b404f64a3da2e5816e05ef8fe179e5f5de8a785640ad5b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b8a226d9c24bd53056f1e5e060eabd3227a4c303da201e7b00b8d048b988c7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "740b746449e919a8f94a0f47dcadf009b2f165c05b814d1e37844094ffcdbda3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd38c853562db649d5e70989b6fac7df39d9d8c9b364433df79b913e8f0fe19f"
    sha256 cellar: :any_skip_relocation, ventura:       "1893fe246cedaef13a84345526280b912102cc936bf22b9d07ec3666f1fd8870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d1e07ef0617df845cc93936ff9d8c9c4a2a87be5edc822d49dd7b9b2260dbd6"
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