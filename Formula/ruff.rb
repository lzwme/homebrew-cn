class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://ghproxy.com/https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.267.tar.gz"
  sha256 "80aec7de147c127ca8f9285c5989a14ab83ad056d08ac2abd9fa01691a1908f7"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "081e25d44a6c90dde16942d25c2beeaab3d8b02ccb5fd4e6f97bb663a995974c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "919c5c73771d3a1c769dab826ccfb015470f970d8992bf46efa1310736619e2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d5ae061298af2345877ab3b189ba5eaa462e1da51421637e35eff703da86c62"
    sha256 cellar: :any_skip_relocation, ventura:        "0a5d7ac91e6c7cc129eb76aa36e761688ad115b5223950cca0922f790b9ecc58"
    sha256 cellar: :any_skip_relocation, monterey:       "551c076ed70e94ec145080f5afcbd88945fb2a04f68cc29d4b3255c79d7e4c4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "44bdd278d370f963393af9a142de7863cbb019217092b524a2d6c8a68d028ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "918303b6ce0e8b3a3b8ea5af1cf1282fee981a7a589dd99a07f956029720487b"
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