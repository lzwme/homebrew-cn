class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "e3b166d193d0d0d908e6165873d38f56e15ee4c1b5a49e890f2eff44aded2817"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f7fa337eb8c5fdd1033a67f66a14f6b01a4e9e0a77a16ec7a346416d620d796"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9d7e0b1dd14b73d90404a9feaf25517186a3fb7e9cdfd6bc0dcbb9f6b2677ee9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59365bfbc54d6b59b36ef70ad4a51194b82339326d801c302f258883161b7d87"
    sha256 cellar: :any,                 arm64_linux:       "2d7cc3320172fa8c3ca61e86ac0612de47801776430f420d1e7ac33156fce4d1"
    sha256 cellar: :any,                 x86_64_linux:      "d311d74d0bc90769dbf4168f967f0894e0a0396e472dac24f5fb093e4ca2b9fd"
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