class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://ghfast.top/https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "da87633aa6a8f24819f2552b628fa820fd1d18c80964513b15a9d285381c7d84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "143d6dc5c0d5b5e9ec92c12e74b20021035edf652f89311d87253f6eed823213"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af4f0f41dc3c6fae6560d3b6b33224cf363d54d8c2faf90b2738ec051beed5a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67919d34ae158a5df0557082ccab45e316e9fecbae9ae28729e11e401273ffcc"
    sha256 cellar: :any,                 arm64_linux:       "b631db73010b8b03320c747e50c63a569e80c3fc97d5d428f56d0e0f9086c777"
    sha256 cellar: :any,                 x86_64_linux:      "5961cb8ca8871bdcb7c10d3f938ca6e97a159f526c2395d197e157841d12cf3c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end