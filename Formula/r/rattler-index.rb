class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.34.0.tar.gz"
  sha256 "01ca2dfd8ca86c7460a3f39d959891f67859b59132eea0b04b3a70f6ece99e70"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb7cf5dcc26137174d402611c6884eb5639c710f5602efebc5e1ac4ebeebc60b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91ea5b49e647d7f4d9ddae4ff4301bf0b47e2a80a80ded207142c94267c955ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f214e50594e98ece68882ae6cfaf0b8d10103fd1ecaf3bc76f308091e132a4c7"
    sha256 cellar: :any,                 arm64_linux:       "3e82e8876894f1bf98f6c011cf68de0c2eefab5f39af679117919acaef47d310"
    sha256 cellar: :any,                 x86_64_linux:      "677f3fa7e9bcab7ed4252763bf74bb8980458b0efec5e81408db585f8ff16bbf"
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