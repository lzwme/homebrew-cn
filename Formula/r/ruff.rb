class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "74d64fb11f5ae5b6da7f30093f8ad30162ffe2f5d930e859978615c6d204d9ea"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "997998fc3671fc128ba770d2e066399f10529af2e885638329d935830173805a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bf3e8dc90fa68ee288b100ffa6141497004bc2049433b6b2653c6499322ebc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c24b4042949eb8ceb3f30608f4584d5b97f2cd27b157bc8a7b063cbbbc92bb11"
    sha256 cellar: :any_skip_relocation, sonoma:         "70c694575311b74146437753f05f1ef0fce7b3af2515b7768014b19324796f18"
    sha256 cellar: :any_skip_relocation, ventura:        "2d259dfe87254a7117780556757f620c69e27ecc9fae2ca38b2fcb294d25e3d2"
    sha256 cellar: :any_skip_relocation, monterey:       "4ad89a2efe67da6554fe4e7da55276d0b2e873131bab9bf3de755fdb51f9bfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54059ac1d49984a01f8a539f5b2dcd61ed33676897e84dd869ebdfb1bccfad55"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end