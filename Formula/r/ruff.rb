class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "34de15692839885e7096893b6df7828385cf562952636478ca56dd904df5dcbf"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "125186ebb72230e3fd1c8298254b078b94eda2a9beee59446c45e2e3a4577106"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9f063dd1ee9eda42ac9015cad377d8055b19f3ae5005c6e742b8c7429a420e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3576081ce9094c91584efea2fd59ff4760fad0954472916035277151bc031bd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "a696d87626e04acbc77b1b55b4a4b92b517f60d9ddd1c5a4436ea94106952fdc"
    sha256 cellar: :any_skip_relocation, ventura:        "52d3c04c3cbefbf99ccbf320552ca5a47cd259aa3e9252d71a9c7a45388078bc"
    sha256 cellar: :any_skip_relocation, monterey:       "38f96b2d38ff7c65469c5fcd18b92243633384e05e1428222f19a7c924664085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c0fc2ee94521091a16fbd8ff24adc202df3db94c9135fbfc6da7bd69f7d37ef"
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