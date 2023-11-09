class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "97bb544485245ea991084af768db240cbba349cbd55fd89ee6944d4037f33582"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf5c255cd3c6a7ba262da533f5059ab74f6685346775524411e6ec0f23c29381"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58213441eab786adc559199e2717097f3ed1bc3ecf69f7352e70f12611e78f20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffa2151af1a6a29a0f641e54544f07691d5391043431a1ae5fc788557e1cc6a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba2a834949a6db130e4c1e181cec4e30c8fc3189eaf90d58e52b87a911668c52"
    sha256 cellar: :any_skip_relocation, ventura:        "1103d96738e62b8fac58421a6d311c8c910cdc5472aee85b27274d204b0bfc30"
    sha256 cellar: :any_skip_relocation, monterey:       "0fe6dc77afd2be2c6c28626b8ede04449e63e9837959b4936cff0ba206ec8ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cddc7f790ac5ef305f762eaeaa4e5fe7fbb8692da69777ff3989739b154d989"
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