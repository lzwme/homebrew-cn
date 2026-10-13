class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.8.tar.gz"
  sha256 "6adbba5dbe752cfcf957ac4c9f4df9c648f6e95a899943a7dddb6a20efda71fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "263460190bfac95b1d562dd3b56d49c7d801d08379b04580b19e569f21e969e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5085b69a4dcad79b4ab00fb357226d2ce40dfb8fe661a296e1aca291ccdedbd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c7b1f56c01e4011c6de1f8819fcd9cbc9047c681bb2b80a4d1344595d0d95c9"
    sha256 cellar: :any,                 arm64_linux:       "340dbefc6659e90d976c022afb030d0bd61217134bdf7834950d0fda573923fd"
    sha256 cellar: :any,                 x86_64_linux:      "df3e70e41c27c4d4c2eed598c3b6cf38a66d330ae173bfa1714ea439ec897fb3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"sofka", "completion")
  end

  test do
    assert_equal "sofka #{version}\n", shell_output("#{bin}/sofka --version")
    assert_match "failed to read kubeconfig", shell_output("#{bin}/sofka --check 2>&1", 1)
  end
end