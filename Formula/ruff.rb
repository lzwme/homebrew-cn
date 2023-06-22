class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://ghproxy.com/https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.274.tar.gz"
  sha256 "f0274494d4d56c4fb3aea1f94a7ef4d167dc968f8d1d5c6e7a3312cdefec8865"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9eeaea7d40f95f970aeca8af6241d1a862f4db146d294dbcdc23ba5862be9d3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88a7ef3475c767210cd0a34fc12809b9eb4f82b5b4485ec96ce83a8f548452eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "254f3e29481615d2c2e04c45f452f7a68664da6f5a069cddd791fdc3d66e0896"
    sha256 cellar: :any_skip_relocation, ventura:        "0213d77fe7bff13861afbb4e78976f59d8b72d8720edea0b76484909a7f4e911"
    sha256 cellar: :any_skip_relocation, monterey:       "a66a027b6c19a37f4d4f4d4376150b6e78aff9166db14ebca74c41a5fa4cbe99"
    sha256 cellar: :any_skip_relocation, big_sur:        "835fdb02eead1dac6d5b8ed4ef80c09b3bc2f3931142dbdf003913fd1c85970f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca85717c4fdd792702e2e2fef7db32a09ca725aedefc044e8d8dcf60365ad40"
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