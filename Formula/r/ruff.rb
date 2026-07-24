class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.16.0.tar.gz"
  sha256 "ad8b06b0badbe45ab34b56e8a71d693936ea343413831fc0475656f358eda25d"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cec057935322348f40175c0fae96329cdcb0a03dc7da90c89d5fad5f5e82810d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60f6cef1149a07f830bcbdfc7cb84506fa50da54286c61dd51178b420a727bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fba504d970b6dbd98828a6e2275e1fcf2430bd7ee4fc21f56c890f6652de87e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac34e618b2c64e86ecb33a496366642fd4a93127f69b1a5531a0afacb3429404"
    sha256 cellar: :any,                 arm64_linux:   "dedfe1f06d3338d512f0bb13bd92c8a34a56ddcaeeddcceda873da379dbda71a"
    sha256 cellar: :any,                 x86_64_linux:  "4c19a59575b9fc40d6713adb5fc5f1dc12dda78dafe57d9c28cdd9437aa8fdd7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end