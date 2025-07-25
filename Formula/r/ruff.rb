class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghfast.top/https://github.com/astral-sh/ruff/archive/refs/tags/0.12.5.tar.gz"
  sha256 "8a3d13cc931a73a83d1a4e26ae500d77900fa847c3062a285f4dd1f4b6180dda"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "409d302cb43b6444cf880acec0eb476a3dab35c13f64870a4402edc38da7b3ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "946cb2a98c48607078b609773027162b2c85b711f42dde9dae809c9ff31e4cca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80d19a78ab701987647b0911c94800f30eba2818cfba25ea03493b39d88fcfc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a4215351e1ec8f7f32d0a20b9596c448fdfc7be3c852147e5ee66b51fbc3bf"
    sha256 cellar: :any_skip_relocation, ventura:       "2dc3ccb6caf471421d30f76b53fe65a4479e2352d963120b87a6b187de620941"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c04e9b23d593633e0a91ad7a74e32f18dadfd2f34c568c494a7e04af999a0b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ada1b2fbf521b61daee69c265d73f7d5b1a82b96b9d2df1e4c23afae5ae00be"
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