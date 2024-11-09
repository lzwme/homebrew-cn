class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.7.3.tar.gz"
  sha256 "6b2aa675bb50124f636bda2c671f3394a8cfc7bf32d2fce63f852f7d43ce4810"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31e3d1faeb5a76295592506e8ccc5afdf9dd6e3877e1d93e21ae8ba2169b48dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7dce309eb9f381e4b197b1a1bbe574057c46271d3ec76c74a1fba18c4d0652c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "669fa75573372d5c7b83d7a54b67ddae80bdba65fccb3af010331907ff232066"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d9580787108a3936822bdd6ec0ba65a73715d2c95dc4a3059443f2e8d36078b"
    sha256 cellar: :any_skip_relocation, ventura:       "ce0cef1750f597dfc7788495fba7a713f142a37b055b0ea590b1f3ca8f4b61ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a06a5798975c0a5f98f862f4e72f64017ddf3b1581fa5cd2f586b09d3e37070b"
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