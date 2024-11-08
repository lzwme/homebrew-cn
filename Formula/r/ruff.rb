class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.7.2.tar.gz"
  sha256 "e678307f10bd316f4bc8f0ca7419646e04be25b387f1ff84ea4470d482e240ba"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08081ef6aae9dfc503389bc01488827fe3add0b8923d235632069bac90e11cac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85bdc489dd9b937c522c67dea87810676ecc8b8e29552dfba259b55336a235c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07293efe0149007c6876dad16c71c6bd046a7825f1010858c75a152d02d95802"
    sha256 cellar: :any_skip_relocation, sonoma:        "d329661e8dd0cfb1cf285dff66420e7c4d1377d0305d7e70ea80107868286393"
    sha256 cellar: :any_skip_relocation, ventura:       "28e86ee34c3bd5e99bff32da84fa970d9ca4a344832e52e6138470e12120443f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2057938fa6efdd07173394b7454b29296bead1889704f34c83d0710d74152150"
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