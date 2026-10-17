class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.11.tar.gz"
  sha256 "cc7bcc51afdc6522c002be197f53ae35434a48ded8a6e6d3772804079df7a2bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3eff7953b7f330febd78c7bf211958620cbffeb6b4fdb6271b1098fb8f4e74bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5229c128f03e57dd75e6f61015f738ed5a43051f2d0115049acd5be1c169f24d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8ebd7bd89668fe6e2fb013f3d338d0055d3b787c980bcec8a948d8613314c53"
    sha256 cellar: :any,                 arm64_linux:       "386252333fddc6aa15cc92eb69809a0b8f6185bd0be8e29982b9ea7e66c7011a"
    sha256 cellar: :any,                 x86_64_linux:      "066e453dcb2ad742e4ff80635ffd4bd4462f2538c6166015dc72f3ef1b5174c5"
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