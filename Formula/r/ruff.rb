class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.4.1.tar.gz"
  sha256 "7213ad13b15e766fb4f5d2fa24ffe1a1a55b47822a159e3c8f64b4a0e6ebca49"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2e2b65a0b049d58f8e57a10846908f79ba79713dea27f018828b290891bdc44"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9c2caf9f9074181bf7a9979315ad535d884c17f76e3295e92c03e6eeceadba0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8a6be3b47e9441bc42efce017a3f492bb7d8d2c19193b49d23b19aa897a1d21"
    sha256 cellar: :any_skip_relocation, sonoma:         "460e16f731c7342e1d17c1cc674140700460bedea40b41da3cb0add39026c75f"
    sha256 cellar: :any_skip_relocation, ventura:        "1162e854e40da607c88d147eac58dc1c24bbb3d730aa9ad4d08553f6431f4763"
    sha256 cellar: :any_skip_relocation, monterey:       "13ab05a0136990ce63657e2cbcfd17d8c191b23fb6296b11f084d6f074c76e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "952937e1753e1785b60b3185a02dd9fbab7a5c0e36a6e1d57f31accd52c1bff0"
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

    assert_match "`os` imported but unused", shell_output("#{bin}ruff --quiet #{testpath}test.py", 1)
  end
end