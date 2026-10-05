class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.29.9.tar.gz"
  sha256 "76ddd5b75244d0f8defb344983617b93740bb286176cb4f2db7103e8e5b34e12"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c522aa7ea0de43f657efcb1e3dbb840d2402f75f7c41529aaf4e69f839f230b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "11bf73844ceb50b627404ac45dd2664a55acaeb3908eb91c49fbdd5d32091e1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff7561db22ceeb8eb9542d14166cc90331ce52030edcb59f00ad5070fef05638"
    sha256 cellar: :any,                 arm64_linux:       "370c5c007961555079cde14ce177c0c09a73a62e5c1fed599556cfcd2f8ff94e"
    sha256 cellar: :any,                 x86_64_linux:      "94fc3586bde128365ff0bbc8058eb8e2d70ead5639b62db10976393e744f7198"
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