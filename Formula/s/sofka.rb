class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.13.tar.gz"
  sha256 "455559e4cb917f72756eb28fec21394c11689cdc515348dc8f5827810b31442f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c00154501653ff58143dd4a827bc40ddc5753d1da460a7ab2e24085d5e2ce1b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a656349974334599c5497b19397f98dcc40b855b903ec5ebe9a7b1d12046143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ee7cf42ecd070c6ce529416c784819aa958a0bb831e22ad46ef70f567057ee3"
    sha256 cellar: :any,                 arm64_linux:       "538db4329a17723a8cd4881811e894730d7a8ef75ac6017413a8e80d6c08f0a5"
    sha256 cellar: :any,                 x86_64_linux:      "782929cb6e8a5a1f1b6e10ca37046b1d8924d7d3484db56ab67ab5a3f012ec46"
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