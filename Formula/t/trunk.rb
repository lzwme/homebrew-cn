class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://trunk-rs.github.io/trunk"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/trunk-rs/trunk.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/trunk-rs/trunk/archive/refs/tags/v0.21.14.tar.gz"
    sha256 "8687bcf96bdc4decee88458745bbb760ad31dfd109e955cf455c2b64caeeae2f"

    # Backport only the openssl and openssl-sys version updates from
    # https://github.com/trunk-rs/trunk/commit/84105e44e2dc0d4ee6a218c0be0030c4bd1e6860
    patch :DATA
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e95ad475c49fbb5322fbbf9549f355f97607f428281812926ce6faffb3821999"
    sha256 cellar: :any, arm64_tahoe:       "cf27a8172e41b8e9ea3f63ce101410665baee65b32ca846854978d21c2f5b5f0"
    sha256 cellar: :any, arm64_sequoia:     "09f4a6c46d1eb6becd97ec0c154116e8b7df5df4006536f5e3ce6ddcb649597e"
    sha256 cellar: :any, arm64_linux:       "9e8758050043ef587c8389de3f576acbe8e4ae023b1a2856bbae469416aebe4b"
    sha256 cellar: :any, x86_64_linux:      "03ed23f22eb0b77134230c94b7ab48df3a76342b70965b508d25f6ccf9b7c07a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  uses_from_macos "bzip2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    # For features, we disable update_check and replace rustls with native-tls
    system "cargo", "install", "--no-default-features", *std_cargo_args(features: "native-tls")
  end

  test do
    ENV["TRUNK_CONFIG"] = testpath/"Trunk.toml"
    (testpath/"Trunk.toml").write <<~TOML
      trunk-version = ">=0.19.0"

      [build]
      target = "index.html"
      dist = "dist"
    TOML

    assert_match "Configuration {\n", shell_output("#{bin}/trunk config show")

    assert_match version.to_s, shell_output("#{bin}/trunk --version")
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index a0a353e..ce6fc55 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -2445,15 +2445,14 @@ dependencies = [
 
 [[package]]
 name = "openssl"
-version = "0.10.72"
+version = "0.10.81"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "fedfea7d58a1f73118430a55da6a286e7b044961736ce96a16a17068ea25e5da"
+checksum = "77823a27f0babb03091cb9ed9ef80af3b39dbc82f97e8fa530374b7dafd87a45"
 dependencies = [
  "bitflags 2.9.0",
  "cfg-if",
  "foreign-types",
  "libc",
- "once_cell",
  "openssl-macros",
  "openssl-sys",
 ]
@@ -2486,9 +2485,9 @@ dependencies = [
 
 [[package]]
 name = "openssl-sys"
-version = "0.9.107"
+version = "0.9.117"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "8288979acd84749c744a9014b4382d42b8f7b2592847b5afb2ed29e5d16ede07"
+checksum = "b47e7e6bb2c38cd930d25a23b40fa52e068c10e85f3e03a7f5ba5aaca5713695"
 dependencies = [
  "cc",
  "libc",