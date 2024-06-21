class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstagsv0.4.10.tar.gz"
  sha256 "cd3212c8e44c0c2c92eba10c44df0ed4073c77b2cff669563b37a56a090c9e74"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21abb43ca09921c0a5dc4b1031fec475127d12ea58e1c1e08ea9a71969aeb3dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79369d5be3fcc61b913bea7dabf9449e5868a570abc9d3980c3ea99f68ecec3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa8836859a3be1041e5cf69c017a73cfa03a393cd4fd2ed0c251c4fa4eacea06"
    sha256 cellar: :any_skip_relocation, sonoma:         "eee6497c376d27bdfbb80ce64853156e628f9ebad1445cead9f661fb897e3fc9"
    sha256 cellar: :any_skip_relocation, ventura:        "69bec408390e0643430a3ed828796d8759bbd650caaff5ff3e6ed39876b221dc"
    sha256 cellar: :any_skip_relocation, monterey:       "6fc4ca5f412656b8b2cc4a537757577889a5286bf997177dacfd208ef7322d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbe4f298b6b3f87c8ead12657863fdd3e43e448c891f537df51b5f0dfe2a4e00"
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