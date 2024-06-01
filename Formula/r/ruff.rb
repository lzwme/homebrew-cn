class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.4.7.tar.gz"
  sha256 "ac4aa8ef072de32e3681ce7e6a126204a8ca30b0a5d512b0c84fb4d116223c41"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "832e7ed3a9962dd11e86f6b8a054a5bc21c03b73b724ea4684d573f94c2cecee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecbedfeaa814bca8b33b29294e60614870723abd9bd1807dd2c0d76defff5c43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3e5c250cde05794d00e3f0132c30cfca76c4692e63cf88eefeff404350109a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "682e69eae6dd417682f988a3f6958c5b52d88153f35b78af929332820b706e8c"
    sha256 cellar: :any_skip_relocation, ventura:        "88db8f47d1cbddc01ee817142633229da8e7d0bf49e28634a946eaa88d2d550c"
    sha256 cellar: :any_skip_relocation, monterey:       "c34dd119f225b3bb0edbf296648a49e222dccbacfb63fcce5e73fb74cf0fa5b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30f034e7659a0bcc6c21d60657e4513a04e23cd981578411dc848508a45464a2"
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