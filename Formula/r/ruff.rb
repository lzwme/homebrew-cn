class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.19.tar.gz"
  sha256 "d333be5ee739764657f4d888ece01b1ee4d5833efb4d31e3c8ed5456e05c616e"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4735392d83c6f53ea06a6bc3a7e6232016bc3163cda51c5e4150743697dd076a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e84f3fab1c0877930526c8f8522782d98ec97ee375eb0207d0dc3b8572f923b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e2f423437c3dfba28c17e0ba0a4088355c70b04f72800f46860963beedf2e7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "de37dc44709669ecd6057fb363ac5fc521bf527dd7d07ae8cce82ba13501ab1a"
    sha256 cellar: :any,                 arm64_linux:   "4c1b87acf95bd8145f247a3674230d391389ed8547a18c4600399d8bbf1c248c"
    sha256 cellar: :any,                 x86_64_linux:  "2d666d255d02e2c611778978fdd0494f394b816ca6841b3c8009d5452b9cad7c"
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