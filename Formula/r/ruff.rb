class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.6.0.tar.gz"
  sha256 "d94016823284229468e8c4196c2e09303b345a3a4d441d16699127592537f3d3"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "969d484505308710a78fd2d1761fd02511f1cec25270910fdff2fb0d475c7c26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2b88f40a9e6b94e6a42807aeee305c23353ab2b0db5b1ee3db5d3b07a097e2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb45ae4ae4235f7206c538942e211b7a6bb80972e0d30c33001df4c6bd878953"
    sha256 cellar: :any_skip_relocation, sonoma:         "262fb066d7d7c44abceae6b5368ae30a512b54e9cf90a39ca1b58d9ce2768b5d"
    sha256 cellar: :any_skip_relocation, ventura:        "52301bbc192a77e991a5dc3176d664a1bb32ab09233b303badf126b757e28479"
    sha256 cellar: :any_skip_relocation, monterey:       "88ade793b8d02934e55d4810acba54e454b9413518a148e363805f405111f0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aa6867598d4637ab710f134d1199f3a1eb6593c5d227f283ca33fdfe3845598"
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