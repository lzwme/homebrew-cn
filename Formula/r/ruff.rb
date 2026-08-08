class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.16.2.tar.gz"
  sha256 "480cd1332b2188403d36906f7d92f4a4bf9a1aead3a12595d08425c5a0520620"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e13df450c7f6a4237b83fe3950fe92ed83120c103840ef2281bb7853ed3fada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aba7004479ba80ec8982ede06866bfb5ef62a81e85047f4a55cdfb8b4f394810"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15215851549874c3857f89e6ede06d64a84eefbc603e3af6d9340ca18ecdfa00"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0e7973f670cc5e42815b0e4462542c6cbd8e1c2625474d3e33140835315aad5"
    sha256 cellar: :any,                 arm64_linux:   "eb9bd9946d88964123431a40809d596324312ddd466beac9e9a95fb0f4d26b09"
    sha256 cellar: :any,                 x86_64_linux:  "57f205ec4b6221e1c01aab9cf57137ffccb01b4f77caf60e7b7c20e4ac7e32d8"
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