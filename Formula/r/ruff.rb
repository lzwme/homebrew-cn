class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.12.1.tar.gz"
  sha256 "a234572ee7b97ad82debdda91987e6d34e71cc74d83275e51524335d0506989b"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7550cafa2fd1c56652b0e2b9e9a1105a5c5f80d1a833ecb408646f1f85ed45e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a774da9333f80dcb8b75e9705901fafe14ed1ad2217c0813a895a26c0509a061"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6c1013b43c4bdc3257f484505a013b8d7e0e5775be38a26bb0bc9eeb453c319"
    sha256 cellar: :any_skip_relocation, sonoma:        "db2951e27bed00c22bd26f06fe7ec1c6421ad564b9e08b1c1f179fef425e5b09"
    sha256 cellar: :any_skip_relocation, ventura:       "dafb9647a581fd12f2543f3608c03546c955f29c59d281e71da0e618ce7ab8a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db12891e398c5d63970ac2efc973da8c107cbee4f060566bd543c0ccea9a5b9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdff8a5825601e1d67f6cca10716149f8d25785079d7bbf8afd14bc93bccda5d"
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