class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.17.2.tar.gz"
  sha256 "32bcb3363a9b5e0111c25c5cd50069b2bd92e370695ba981d5dfbc48e7ecb1a0"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19de8ba04a85b4696ca1a7f7ecd7db9cabe7c0c6fef7e8d95d848fa102bc8ddc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "59d9388e3667ab4f475e83047398fbd981d943026b3d492498bd1187c7ed0e0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "137e7a57974c8fb507350f29b04db253e3e4b7b3dac8d8fecab01fb78d62275e"
    sha256 cellar: :any,                 arm64_linux:       "61696d263bec90c180d46e151313ed28d2735932f78ea7b00ea78c9f6b4dcbda"
    sha256 cellar: :any,                 x86_64_linux:      "c1291c4ea70090d077763aa6c0eed6b5b6b1b6b2e910efe38911a8e96bb1d0ea"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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