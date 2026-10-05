class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.32.0.tar.gz"
  sha256 "9dd5f4d61560208cc2a34d174806171e9c0c8cd978022606976b162d22e807d5"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d94eec0d31585054e0ed90d3cd6cda0210ef60caaddc8b124c71a811dc2b5c7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8cea88d699bf5dde7875d5cde70ed41cb5b22c79a6d0c1738158eda83d02a1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75839a095bb12c97682dc9b779a2ce60d130bbc4451f25d05a52ecfb749d3f8b"
    sha256 cellar: :any,                 arm64_linux:       "c84fc176fae4e3f0edf401f2bf1babca18be9a9c80b88b6707b783f739e711f0"
    sha256 cellar: :any,                 x86_64_linux:      "6c72bd812f30b3b0239b18518e9b4507a8984407123470c114a26d441e922284"
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