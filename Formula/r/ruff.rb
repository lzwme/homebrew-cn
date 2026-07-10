class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.21.tar.gz"
  sha256 "1916f5c69d8f0b6f06242b94f4326bc6d3f1865c85dc8cbe843b36d88c6baac4"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5b3da1afb76c188fa59ec74cf5d36a9529ecd74e9b7945a36bd008314ab8009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f9b3808f3610e388045ba7f84f59ced452c7423299dd482b7513e6436647aaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc572c98d8da65679252c2a899c8f758c7550f1b161deb2c0ca148de14517d32"
    sha256 cellar: :any_skip_relocation, sonoma:        "64929fc7d6aece30f114bae2841baa7e7b54159b541832ec4b9723995a58ac91"
    sha256 cellar: :any,                 arm64_linux:   "a3b6d836cd955f35b38930c20e3d4052a5b9e9e455d5f827d0bfc84d2fa0a3a7"
    sha256 cellar: :any,                 x86_64_linux:  "1c8589c777293b6313aed799d5bb4e49d34ad799a7e7c315a8448c949e679949"
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