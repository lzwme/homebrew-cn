class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.9.5.tar.gz"
  sha256 "b17cd4352d28a6e949dde559faf4e599fb3a85228ea16727a6169a956715f565"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d203215ac46060e91e5a995d4c9e8fc021d4c5420eca4ee8e701e87e2df240f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d00e1c6b7c85d5f984ff21a1f83cdc555335904900846b5fb1af292d06d3601"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90d7fd0cc37a288f5b5ecf721bca92a47a60fab139ef7cc673b9eaf53fb62ea5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a8b820769eb60f350024ef19b30b951d4bdc65e4547ef5421a1516bec43bf6"
    sha256 cellar: :any_skip_relocation, ventura:       "dfbff8adfc957187bfbb852ee5616dd259031cda44c3cd90e32c02c5b0e44d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f79b629cade365dbd11172a49d856fe242b0d7aff49ac76be5fe92e267e0d6f5"
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