class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.12.tar.gz"
  sha256 "9005209d5e0792b7059b4cd36fb5e96f2f258da3d2ffa4b4f0d5912b158f8ee0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6325b0359783f9f56917d57d2c1678066677526693eb706baa60dd8eb465d95b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43bd8c9e42c019687f9f707901d1834c99e7366873eec8f0870e470b5db203c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dcd569be1bcb2792c3c781ece06757474f9cfd0b61387c6b7225008a14f3622a"
    sha256 cellar: :any,                 arm64_linux:       "45e0bffc692d2cfcc60e1517bf0984cd8d9947d4ef24c6d7a85ec28f9933d071"
    sha256 cellar: :any,                 x86_64_linux:      "7033c265f050e9fabda3663f6b69e0456589e717ed761a923761d38f95191f97"
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