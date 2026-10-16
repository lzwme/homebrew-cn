class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.10.tar.gz"
  sha256 "53294a19fb930b7c087b19c7f94e5735ef32d0506a51266737b5a751c0ea168b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cfcb1e54d610d74bf449e05918611e193fe44fbcf493494fd608dbb9c38f93e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0cc750a2a2e040c6854f3815cd12b8dcd6d4d1ef1a5a275548a7159457b65db9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1fe4147e1083b4ca2e211f2e47d3c095d69791863b752d80e241951ccc497c62"
    sha256 cellar: :any,                 arm64_linux:       "338daa2d3ce579223b2ba5d45f9ffe369ee471d6a55cab79961145c69e4486c5"
    sha256 cellar: :any,                 x86_64_linux:      "6cdd691e3908b09bf3b49364ca081eff144dfa0f0f2c9d9a5b232c3508759271"
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