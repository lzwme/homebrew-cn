class AllSmi < Formula
  desc "GPU monitoring tool for NVIDIA/Jetson/Apple Silicon/Tenstorrent"
  homepage "https://github.com/lablup/all-smi"
  url "https://ghfast.top/https://github.com/lablup/all-smi/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "31703c3b4a0bcb53eec9bd9c613a4327e310459bb5f22d0b276a69de989b3a8f"
  license "Apache-2.0"
  head "https://github.com/lablup/all-smi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd1b38bd00fa9091f78381ff69281c6601b5db634c951fdc2ea97d7df1446b09"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9824a91fbc8cd5c582fc007f6e44071580f3d99c5373f9ddac9aea63b52db0bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1fe7a29dc04fed1d56400fca1964a5c200ac7469a6b816ad5e32ba707b6a5bb9"
    sha256 cellar: :any,                 arm64_linux:       "6bf8a8abc22c3436131368a607913858529f30a420ce27cd72ae3176184c4090"
    sha256 cellar: :any,                 x86_64_linux:      "1d872a8167290426bb12922f373ef3ce01a2b71c680e7e11232aa431468c5fe2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "protobuf" => :build
    depends_on "libdrm"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--target-dir", buildpath/"target", *std_cargo_args
    man1.install "docs/man/all-smi.1"

    return unless OS.linux?

    system "cargo", "build", "--release", "--locked", "--lib",
           "--target-dir", buildpath/"target", "--package", "all-smi-amd-plugin"
    (lib/"all-smi").install "target/release/liball_smi_amd.so"
  end

  service do
    run [opt_bin/"all-smi", "api"]
    keep_alive true
    log_path var/"log/all-smi.log"
    error_log_path var/"log/all-smi.log"
    process_type :background
  end

  test do
    assert_match "all-smi #{version}", shell_output("#{bin}/all-smi --version")

    system bin/"all-smi", "--config", testpath/"config.toml", "config", "init"
    assert_path_exists testpath/"config.toml"

    output = shell_output("#{bin}/all-smi --config #{testpath}/config.toml config print")
    assert_match "schema_version = 1", output
    assert_match "default_mode", output
  end
end