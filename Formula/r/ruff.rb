class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.6.5.tar.gz"
  sha256 "ecca79da8acf4e1f234652fcb1fadef913392e66795b61db1c469c1e34b8fe49"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b337e949aae4423f88ba343f06e80637e17a046e562f4f58de0fecf568c0ef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5441b499df701e2708bfd3202f1a1e7805ec302b97e2d049d5c102cdc92049e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27916715a079dceb7c4b14fe708017ce47b0fd2c39ad2550dd1325a4d1ecfc59"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d69fa62a5ef1ec61c4e7dbc0d92690a0c1e888b51a26cb30e5f3380d531e7e1"
    sha256 cellar: :any_skip_relocation, ventura:       "b42b47f7be5fcde61fb607e093cac9cadadfb4e7f6b18503143465121bdc83d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24d266105030192228e5d6946ebedc91ffb2cddb961b069ca96415528f779e4b"
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