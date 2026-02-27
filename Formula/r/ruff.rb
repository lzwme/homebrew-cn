class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.15.4.tar.gz"
  sha256 "dfe55be1f641b12cb2b9e7d2974afc1db56dc766d144a030accd9fcecbdbad59"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed8d99ebcc75d8c91b8f1976e5587c0743aa72e801076c2629ab4c78c6250a52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c82900fd069e5cf524ec87c30d849fc058767f6b5992f412a5ae96105d530762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "533751d583b2fb5ea7cd2e84e834cdfa3a1a8e02978a6cbfe23d033fa6f4a66a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c9c411d1e6fdd861f0eca66dfcfb5c11271b6d748c76ed51512f118076cb053"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4242faf89238fd655d53b93fe85445b3c9b6f2dad094dd136b7649b5b8219b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a6df8faf009b245acae7a3fc3be2217e967c81207d2c48732223340716b6e7b"
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