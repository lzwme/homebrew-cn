class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.7.tar.gz"
  sha256 "fa49b3a3d01bf938e1051c9b9b83038656451c1b3243636015424fc5f69a35db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6058e1e9344d5134d9aedeea4aabb236b98b08cb3049b68ef64c3baf11effccc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5567b142586d050dfc5ed9d3548bb3375cccde707647ab7fe5a79abf621dfbc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ad8d1d1240144594a36e077301e642c22e05b793b4898ec90c52810edbba122"
    sha256 cellar: :any,                 arm64_linux:       "a8e80d90c664bb390dbfea2b27243cf051dc338064ce995bd514784133a8c86a"
    sha256 cellar: :any,                 x86_64_linux:      "5756220fd1169681081857a8b277c904dc441d35a93de2277c22d063b2f44e69"
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