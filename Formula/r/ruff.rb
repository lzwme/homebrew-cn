class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.288.tar.gz"
  sha256 "56ab331c079baa72d5f1d674d0a00792fb63b41078b5bc3a4f04d32be0cf4d3f"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7525b149c2b28dae70c1a52e93cda9e73ddd7045d85d5c1b83e3733dcc4f66b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d911761ca3400b606e396d8a2d34cf9013a0f2e0ff5d718b2fd83b0dcedad2cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e2b94832d116956716b5bb7a62a878fa94e86dbe6273ca60c778f8c63d790e8"
    sha256 cellar: :any_skip_relocation, ventura:        "8dde1a23aed2fb5340bf9404b7ec28ec2025bcf7ce180f037643e4da037406a7"
    sha256 cellar: :any_skip_relocation, monterey:       "a39ef4e40ef42701201a7f08baa53c5f0b0b755f7c706ff8f712b7269d19becd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6504767d3f58e68586230c97e5a7e10acdddab263452f144414a740203323c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1837a50fd44f06df41cc6cad365f539e763bc4b28bb023e508f788b8ad67a422"
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