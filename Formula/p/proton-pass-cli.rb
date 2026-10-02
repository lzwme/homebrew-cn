class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://ghfast.top/https://github.com/protonpass/pass-cli/archive/refs/tags/2.4.2.tar.gz"
  sha256 "75f9212c548e1e8d5358b1ace7b825e6352aad3d7454e4339fd04b261a4f6db2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f4d60ca8b43c395743bfbfaf09e634c574feea775198605babd8dc05caa3c4bf"
    sha256 cellar: :any, arm64_tahoe:       "a6d1fd2598d0eb36f0794c7ffc3bf5ba79b959acf501148d3dc21611f093b14c"
    sha256 cellar: :any, arm64_sequoia:     "30a180aa233682d87c00abcce7a28bf5876b76cfe68d38a6a5ad50a2f8c92350"
    sha256 cellar: :any, arm64_linux:       "79d476ad315222de3e639dfece09007c2b0ca461507b0b2b3094f67e37c33428"
    sha256 cellar: :any, x86_64_linux:      "b4b7bcb6b19c3c50512c5ce68f2475d5dfbe358b8a4e4f6d0ba1cd736138d27d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  # Upstream does not currently accept external contributions.
  # Regenerate lockfile
  patch :DATA

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    ENV["PROTON_PASS_KEY_PROVIDER"] = "fs"
    output_log = testpath/"output.log"
    pid = spawn bin/"pass-cli", "login", [:out, :err] => output_log.to_s
    sleep 5
    assert_match "Waiting for authentication to complete", output_log.read
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index b2c4e0c..6c8e353 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1114,16 +1114,6 @@ dependencies = [
  "crossbeam-utils",
 ]
 
-[[package]]
-name = "console_error_panic_hook"
-version = "0.1.7"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "a06aeb73f470f66dcdbf7223caeebb85984942f22f1adb2a088cf9668146bbbc"
-dependencies = [
- "cfg-if",
- "wasm-bindgen",
-]
-
 [[package]]
 name = "const-oid"
 version = "0.9.6"
@@ -3239,9 +3229,9 @@ dependencies = [
 
 [[package]]
 name = "lazy_static"
-version = "1.5.0"
+version = "1.5.1"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "bbd2bcb4c963f2ddae06a2efc7e9f3591312473c50c6685e1f298068316e66fe"
+checksum = "20870f649af7073d53e38067b2a84312175d56ea15217e1b15bc83506ec50afb"
 dependencies = [
  "spin 0.9.9",
 ]
@@ -4342,47 +4332,6 @@ dependencies = [
  "tokio",
 ]
 
-[[package]]
-name = "pass-mobile-sdk"
-version = "2.4.2"
-dependencies = [
- "anyhow",
- "async-trait",
- "pass",
- "serde",
- "serde_json",
- "tracing",
- "tracing-subscriber",
- "uniffi",
-]
-
-[[package]]
-name = "pass-uniffi-bindgen"
-version = "2.4.2"
-dependencies = [
- "uniffi",
-]
-
-[[package]]
-name = "pass-web-sdk"
-version = "2.4.2"
-dependencies = [
- "anyhow",
- "async-trait",
- "console_error_panic_hook",
- "js-sys",
- "pass",
- "send_wrapper",
- "serde",
- "serde-wasm-bindgen",
- "time",
- "tracing",
- "tracing-subscriber",
- "tsify",
- "wasm-bindgen",
- "wasm-bindgen-futures",
-]
-
 [[package]]
 name = "passkey"
 version = "0.5.0"
@@ -5997,15 +5946,6 @@ dependencies = [
  "serde_core",
 ]
 
-[[package]]
-name = "send_wrapper"
-version = "0.6.0"
-source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "cd0b0ec5f1c1ca621c432a25813d8d60c88abe6d3e08a3eb9cf37d97a0fe3d73"
-dependencies = [
- "futures-core",
-]
-
 [[package]]
 name = "serde"
 version = "1.0.229"
@@ -7243,9 +7183,7 @@ source = "registry+https://github.com/rust-lang/crates.io-index"
 checksum = "76407f5f396a2c949a069eff4a9fca9ce462410eb872bffef4c2b7b89804a77a"
 dependencies = [
  "anyhow",
- "camino",
  "cargo_metadata",
- "clap",
  "uniffi_bindgen",
  "uniffi_core",
  "uniffi_macros",
@@ -7955,9 +7893,9 @@ dependencies = [
 
 [[package]]
 name = "yoke-derive"
-version = "0.8.3"
+version = "0.8.4"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "33811428bee40dbceb6d545e95754741d17a6aef9a4849f0fd62e2ba4f412a78"
+checksum = "ec8ebde2db3681e8c9980cc27822030e68752690ddfa9473e739aeb4dbde6d71"
 dependencies = [
  "proc-macro2",
  "quote",