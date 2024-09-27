class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.6.8.tar.gz"
  sha256 "27765b3018646745b064ea5734a4f1ba36dede3df3883dd5d150e8307e5d2149"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd70edbe7c79a6335694d903432e2eef1da486c5f4bd8b768ca9f31e5a8dfba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a201d69fea1bd5ce4e35a331893bd2563b6034e49496413d2c1b10098ad9bd03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7dba4fd4a061975c1dab7168b8de31779f042e6b8baab0d04886673177bf20f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e09e72b061697ce38026ab4c2463082962ccf5d2bf284993e49acfc0caa7580"
    sha256 cellar: :any_skip_relocation, ventura:       "b104871841466fcbe8b851bb461adf8b50fddd0fbf98438fc4bb89ce45582165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fc32f4428a2ea011e5bf0d43102aca03518f84106e5c70930fd1bf0951e7671"
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