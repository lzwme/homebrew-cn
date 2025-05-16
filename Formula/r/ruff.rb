class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https:docs.astral.shruff"
  url "https:github.comastral-shruffarchiverefstags0.11.10.tar.gz"
  sha256 "c59405d873151adc5bfa60436ee277ecc33029ef10996795de132182a86c3398"
  license "MIT"
  head "https:github.comastral-shruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c9d35d251d22c9946200b3bb6e0f6d9e56c10ffdfd0ccfcacbcb24cd61d46dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec8d751138fa779ed8c72cbf19c1f5ee062ebff412ad9db0b9fc2897ba6a00c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b01800bc9658cf9b1c959dbdaede3ca1ebbdc4744e3a6dcc65f822d7e3d11d8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "22288ad3889253b06c23d9e4355c6ecc93c9f1adb80cc5f6be19db0d9a777837"
    sha256 cellar: :any_skip_relocation, ventura:       "e79a5e3af56234b515169c4c8e8847106fb178b29c0009c7e8403e26a42f5f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cde46c1e89148b66bcd96499d77edcabc89ba9942ac78763ae02d1843ab41420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c2677d68bc554855e6882e742b24ef1b6a2c1639dfb0262050df02a7fff249a"
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