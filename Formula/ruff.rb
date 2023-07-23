class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://ghproxy.com/https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.280.tar.gz"
  sha256 "9ea57a4dbad87afabe4af6e2022ac09f23ee46eb24c7cb39ac36a52cd6350419"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0703b6eba718fcd1eee8d5eae60f62fd29480ce9cc46a92e1c8be7d9991372ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d12e03c7be3b725b8ae0f5692d3bebb657932be352d8fc816eb856973f2d2ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d001fba3e320db63c03faac4ed26ddbf97b334f454d9a7d51ec3174899620f0"
    sha256 cellar: :any_skip_relocation, ventura:        "201a2da4d9dad3212f67c6bc74c9123e103c4f741a4716ca1c04a765313b10f6"
    sha256 cellar: :any_skip_relocation, monterey:       "90ebb3f8609d546e0ca4415594ddae2b58e9a5233fbeb46d92bc1eceef841d6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "98f24758e33db92a2991b774248b92cfb67f79492eff12e64187ea4025442362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a22f0956b4ab5f47988e388a1ae974abb2bf5046695323e8572a88ee4b9906e"
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