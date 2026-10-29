class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.34.2.tar.gz"
  sha256 "acecfe1230383cdc73afc4f711292dd6813fb4377fe91e60bc221aef98eead05"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ba4991ea5ecd8bcaa6639fdc1e33dcba9e94eb1ba8e1d40364a57b137bef8afb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0c8ba2f6c3c4138d3034eeb9371794346c320c5ecba85521809e294a7ea4a3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a23355a63874702dfc2aa2a8e26a90e774a656b503072d5d6e30a6a98077a14"
    sha256 cellar: :any,                 arm64_linux:       "cf74c1e2c439f02c8abbe4e7a10963c356cd52e99b8a105778d9cb4fc22b779e"
    sha256 cellar: :any,                 x86_64_linux:      "ade441104703e43a8dc83a08099f4d377248265d3118b557ce26557bd3485f5e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end