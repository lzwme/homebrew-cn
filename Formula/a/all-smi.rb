class AllSmi < Formula
  desc "GPU monitoring tool for NVIDIA/Jetson/Apple Silicon/Tenstorrent"
  homepage "https://github.com/lablup/all-smi"
  url "https://ghfast.top/https://github.com/lablup/all-smi/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "52d01dbfa3565b38860538edfcffd834c5190649c926d605d1677883371fb75c"
  license "Apache-2.0"
  head "https://github.com/lablup/all-smi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33cc1de6971918ef8c43793409a0a87638bfa53963485980fae5bc3e9b3a9b4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c0376fe6491dc533a89d529cd8e4957f783ed42cfd563af6b894b27443d8c02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7f640c6512a8bbc3ca8b5f838749710110c1d85bc6266d2b345c61b2fed1efd"
    sha256 cellar: :any,                 arm64_linux:       "f5c5394a96c1159a3c2897269fcab2a4d8250b50612b09cab1db3f13696c0f75"
    sha256 cellar: :any,                 x86_64_linux:      "3c6cabcde7d4db3767b2baabc5c8c675a6f4b8c05a7159ced499e3bfacb91255"
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