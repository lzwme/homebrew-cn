class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.4.tar.gz"
  sha256 "530bfc5e218c53ae8ea22e7a05aacbfa3c03a20adf7db637b8d1266b51f5151e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7825ff505b9a0855e099ace6f8cc6242bea09f14868255552daf65710d3b1703"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b60d9459caff6c4ede71a4e851c3c97e17bea9b9fdc977292c2b16d13ffc2ecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "93fc776a844f91c8782ca31ee3d8161a0ab004a6d0c0253375e4b498f482a22b"
    sha256 cellar: :any,                 arm64_linux:       "06a386ca561f4b3d35f53f6a334d2e002a6ec9683c700f4182f94bc7302d5324"
    sha256 cellar: :any,                 x86_64_linux:      "41ddfc40175c95c6e851e93c8ce3515d01a3ee43b822f29257b5760c4e6abbcf"
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