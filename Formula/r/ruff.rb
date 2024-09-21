class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.6.6.tar.gz"
  sha256 "3cb23639fe8f64748fd3ff0d4a7ed8128ed2a614def511978ee83c798ca0c0ce"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e85d7eefcc77d903662319ba94a4de325e84c79a9e3d43ba202cf565a9718f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "426e94017f612842264d7cdbb4f177d59316a49eab41f2dc53a3164e36e4e06a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbad72ec096164359cfe47a07f63dc31414ffbc669fd3bafa908b4b52455eb2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe9e8d84d60874f3ab80e8e460b82ff6c21fdcc5ee4dc48169d01a4a81fd55a7"
    sha256 cellar: :any_skip_relocation, ventura:       "65b30ddd363e71f61198428b4ea20bb061880f0c1a65236930a1b4b455b458cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aafb67d9be181a2cd26fb6ed5fd015f3ecc41ba56dd70f02d47fe4296e878d6"
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