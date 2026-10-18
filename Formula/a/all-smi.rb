class AllSmi < Formula
  desc "GPU monitoring tool for NVIDIA/Jetson/Apple Silicon/Tenstorrent"
  homepage "https://github.com/lablup/all-smi"
  url "https://ghfast.top/https://github.com/lablup/all-smi/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "252c719d5ce0edbc8f99ad83849bd261a881b76691a339307e097747bf3d1e37"
  license "Apache-2.0"
  head "https://github.com/lablup/all-smi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "663aad5ea3d662880e8fc36e7bfc6077add6b7388cd8711fb7dc7edbad08c973"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e7ff9722564ad76f646a959d2af6f842dd37e1cb63d1fad69a5a57ae8e43d3d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c595f8b22103c33c01aacdb62b1881799b3f5b3c3d97c56c367abf64ae15b607"
    sha256 cellar: :any,                 arm64_linux:       "6b572da5132a62bafc33ed8bd8e612a5a436c83bdbe58f5b12727c485fb8845a"
    sha256 cellar: :any,                 x86_64_linux:      "f1f317394b954e5996f037b8f73913c1d08133a1723bcb3b4d3ad1a53e98e0e4"
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