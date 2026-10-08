class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.33.2.tar.gz"
  sha256 "f3d581764858ecbefeaf4b44b420076b56fe7a546bb003355150246a38f425b0"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c4d450bb4d6e62cb7a0681ff9b90ebf19eb28da96c0058737a0b6250632d728"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfde4e2fc1d0ecd13c34799e6f33afabbba9e0c82251773f686530665d08f4e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4fc614bed9e8dba5da7694e7a86e32e9ee7fb7141049c26d70abe77ecdaf5c18"
    sha256 cellar: :any,                 arm64_linux:       "e0cd08df92ce38337c89dee6f9d773fcffca444d739d3414aa57a971ffe58e06"
    sha256 cellar: :any,                 x86_64_linux:      "a7ef41056a0bb56d27f06966afbda82672b4ad7733eac7ae8f5c8fe10df1a4d6"
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