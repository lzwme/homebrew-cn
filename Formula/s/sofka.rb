class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.29.4.tar.gz"
  sha256 "707f1e2efd81212baaaddf26868bdad6c95c088bd8e8c289178ba4b2f018a0ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38373bf88057d51836247438511c0337c90e25716d567cbd51c0d09a954fa6c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c59156f9cab691160b2c22edeebbb499c55fdb3a5848e2ecbe1c2f638e3aa30e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18cfeba23f5161303334ea8adf60dfa5e1a9df0b3ecf153a30e2432efd8fad77"
    sha256 cellar: :any,                 arm64_linux:       "eb7bf9b53e6aa86aa1209bf8a9cc9c25bb7776daef74a65687e637a570b305ee"
    sha256 cellar: :any,                 x86_64_linux:      "ccff70a9c61557b714d0da1ba38b4b90373b219ffff7be5bf302e010dd644916"
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