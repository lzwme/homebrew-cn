class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.com/"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/denoland/deno/releases/download/v2.6.1/deno_src.tar.gz"
    sha256 "d7d04f94210e809a10081006f7c18fad7fe6a8ca1d3d07fe2cb9e1269638e936"

    # Patch to build against rust 1.92
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a12b903386cfb67c342f1782bb353da875f7c04351585978b854dad8906b20a7"
    sha256 cellar: :any,                 arm64_sequoia: "abaaf945001ee7e0fb22fedc1e97ba3451a7d36b0a0dbf292b0ffddf2834ca3c"
    sha256 cellar: :any,                 arm64_sonoma:  "c63fe6f04513b02b98cfb86893bec990a5c7931b17c0a312f7c96f9c40274aa8"
    sha256 cellar: :any,                 sonoma:        "4bd457b7bee29d4dbbb51d14b6d332165e82e2d291412098ec4915fae87611ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd9328ebb7aee198ac9aab61985737859283921b788f6237bbf55c67efc4ff2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fc66bce698910b2d38f69422f117b68959d43ad722c560619ea08a597859a3f"
  end

  depends_on "cmake" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on xcode: ["15.0", :build] # v8 12.9+ uses linker flags introduced in xcode 15
  depends_on "little-cms2"
  depends_on "sqlite" # needs `sqlite3_unlock_notify`

  uses_from_macos "python" => :build
  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "glib" => :build
    depends_on "pcre2" => :build
  end

  def llvm
    Formula["llvm"]
  end

  def install
    inreplace "Cargo.toml" do |s|
      # https://github.com/Homebrew/homebrew-core/pull/227966#issuecomment-3001448018
      s.gsub!(/^lto = true$/, 'lto = "thin"')

      # Avoid vendored dependencies.
      s.gsub!(/^libffi-sys = "(.+)"$/,
              'libffi-sys = { version = "\\1", features = ["system"] }')
      s.gsub!(/^rusqlite = { version = "(.+)", features = \["unlock_notify", "bundled", "session"/,
              'rusqlite = { version = "\\1", features = ["unlock_notify", "session"')
    end

    ENV["LCMS2_LIB_DIR"] = Formula["little-cms2"].opt_lib
    # env args for building a release build with our python3 and ninja
    ENV["PYTHON"] = which("python3")
    ENV["NINJA"] = which("ninja")
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = llvm.prefix

    # use our clang version, and disable lld because the build assumes the lld
    # supports features from newer clang versions (>=20)
    ENV["GN_ARGS"] = "clang_version=#{llvm.version.major} use_lld=#{OS.linux?}"

    system "cargo", "install", "--no-default-features", "-vv", *std_cargo_args(path: "cli")
    generate_completions_from_executable(bin/"deno", "completions")
  end

  test do
    require "utils/linkage"

    IO.popen("deno run -A -r https://fresh.deno.dev fresh-project", "r+") do |pipe|
      pipe.puts "n"
      pipe.puts "n"
      pipe.close_write
      pipe.read
    end

    assert_match "# Fresh project", (testpath/"fresh-project/README.md").read

    (testpath/"hello.ts").write <<~TYPESCRIPT
      console.log("hello", "deno");
    TYPESCRIPT
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "Welcome to Deno!",
      shell_output("#{bin}/deno run https://deno.land/std@0.100.0/examples/welcome.ts")

    linked_libraries = [
      Formula["sqlite"].opt_lib/shared_library("libsqlite3"),
    ]
    unless OS.mac?
      linked_libraries += [
        Formula["libffi"].opt_lib/shared_library("libffi"),
      ]
    end
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"deno", library),
              "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end

__END__
diff --git a/cli/cache/cache_db.rs b/cli/cache/cache_db.rs
index a1d4acf6..8e722123 100644
--- a/cli/cache/cache_db.rs
+++ b/cli/cache/cache_db.rs
@@ -605,7 +605,7 @@ mod tests {
     assert_same_serialize_deserialize(CacheDBHash::new(u64::MAX));
     assert_same_serialize_deserialize(CacheDBHash::new(u64::MAX - 1));
     assert_same_serialize_deserialize(CacheDBHash::new(u64::MIN));
-    assert_same_serialize_deserialize(CacheDBHash::new(u64::MIN + 1));
+    assert_same_serialize_deserialize(CacheDBHash::new(1));
   }
 
   fn assert_same_serialize_deserialize(original_hash: CacheDBHash) {
diff --git a/cli/lsp/tsc.rs b/cli/lsp/tsc.rs
index e509c40f..ef643c03 100644
--- a/cli/lsp/tsc.rs
+++ b/cli/lsp/tsc.rs
@@ -52,7 +52,6 @@ use deno_runtime::tokio_util::create_basic_runtime;
 use indexmap::IndexMap;
 use indexmap::IndexSet;
 use lazy_regex::lazy_regex;
-use log::error;
 use lsp_types::Uri;
 use node_resolver::NodeResolutionKind;
 use node_resolver::ResolutionMode;
diff --git a/cli/tools/coverage/util.rs b/cli/tools/coverage/util.rs
index e61830b7..c4333513 100644
--- a/cli/tools/coverage/util.rs
+++ b/cli/tools/coverage/util.rs
@@ -54,7 +54,7 @@ mod tests {
 
   #[test]
   fn test_find_root() {
-    let urls = vec![
+    let urls = [
       Url::parse("file:///a/b/c/d/e.ts").unwrap(),
       Url::parse("file:///a/b/c/d/f.ts").unwrap(),
       Url::parse("file:///a/b/c/d/g.ts").unwrap(),
@@ -71,7 +71,7 @@ mod tests {
 
   #[test]
   fn test_find_root_with_similar_filenames() {
-    let urls = vec![
+    let urls = [
       Url::parse("file:///a/b/c/d/foo0.ts").unwrap(),
       Url::parse("file:///a/b/c/d/foo1.ts").unwrap(),
       Url::parse("file:///a/b/c/d/foo2.ts").unwrap(),
@@ -82,7 +82,7 @@ mod tests {
 
   #[test]
   fn test_find_root_with_similar_dirnames() {
-    let urls = vec![
+    let urls = [
       Url::parse("file:///a/b/c/foo0/mod.ts").unwrap(),
       Url::parse("file:///a/b/c/foo1/mod.ts").unwrap(),
       Url::parse("file:///a/b/c/foo2/mod.ts").unwrap(),
diff --git a/cli/tools/pm/audit.rs b/cli/tools/pm/audit.rs
index d3da714b..735d1557 100644
--- a/cli/tools/pm/audit.rs
+++ b/cli/tools/pm/audit.rs
@@ -504,9 +504,9 @@ mod npm {
             action.action,
             action.module,
             if let Some(target) = &action.target {
-              &format!("@{}", target)
+              format!("@{}", target)
             } else {
-              ""
+              "".to_string()
             },
             if action.is_major {
               " (major upgrade)"
diff --git a/libs/npm_cache/remote.rs b/libs/npm_cache/remote.rs
index 56156a80..9131d36e 100644
--- a/libs/npm_cache/remote.rs
+++ b/libs/npm_cache/remote.rs
@@ -36,16 +36,18 @@ pub fn maybe_auth_header_value_for_npm_registry(
     return Err(AuthHeaderForNpmRegistryError::Both);
   }
 
-  if username.is_some() && password.is_some() {
+  if let Some(username) = username
+    && let Some(password) = password
+  {
     // The npm client does some double encoding when generating the
     // bearer token value, see
     // https://github.com/npm/cli/blob/780afc50e3a345feb1871a28e33fa48235bc3bd5/workspaces/config/lib/index.js#L846-L851
     let pw_base64 = BASE64_STANDARD
-      .decode(password.unwrap())
+      .decode(password)
       .map_err(AuthHeaderForNpmRegistryError::Base64)?;
     let bearer = BASE64_STANDARD.encode(format!(
       "{}:{}",
-      username.unwrap(),
+      username,
       String::from_utf8_lossy(&pw_base64)
     ));
 
diff --git a/runtime/web_worker.rs b/runtime/web_worker.rs
index 84db2cff..e7d52432 100644
--- a/runtime/web_worker.rs
+++ b/runtime/web_worker.rs
@@ -600,10 +600,12 @@ impl WebWorker {
     ];
 
     #[cfg(feature = "hmr")]
-    assert!(
-      cfg!(not(feature = "only_snapshotted_js_sources")),
-      "'hmr' is incompatible with 'only_snapshotted_js_sources'."
-    );
+    const {
+      assert!(
+        cfg!(not(feature = "only_snapshotted_js_sources")),
+        "'hmr' is incompatible with 'only_snapshotted_js_sources'."
+      );
+    }
 
     for extension in &mut extensions {
       if options.startup_snapshot.is_some() {
diff --git a/runtime/worker.rs b/runtime/worker.rs
index 89297b0c..ae976b8e 100644
--- a/runtime/worker.rs
+++ b/runtime/worker.rs
@@ -444,10 +444,12 @@ impl MainWorker {
     }
 
     #[cfg(feature = "hmr")]
-    assert!(
-      cfg!(not(feature = "only_snapshotted_js_sources")),
-      "'hmr' is incompatible with 'only_snapshotted_js_sources'."
-    );
+    const {
+      assert!(
+        cfg!(not(feature = "only_snapshotted_js_sources")),
+        "'hmr' is incompatible with 'only_snapshotted_js_sources'."
+      );
+    }
 
     #[cfg(feature = "only_snapshotted_js_sources")]
     options.startup_snapshot.as_ref().expect("A user snapshot was not provided, even though 'only_snapshotted_js_sources' is used.");
diff --git a/rust-toolchain.toml b/rust-toolchain.toml
index 43e5784a..1a216558 100644
--- a/rust-toolchain.toml
+++ b/rust-toolchain.toml
@@ -1,3 +1,3 @@
 [toolchain]
-channel = "1.90.0"
+channel = "1.92.0"
 components = ["rustfmt", "clippy"]
diff --git a/tests/specs/test/recursive_permissions_pledge/err.out b/tests/specs/test/recursive_permissions_pledge/err.out
index a3f151ee..912a3e63 100644
--- a/tests/specs/test/recursive_permissions_pledge/err.out
+++ b/tests/specs/test/recursive_permissions_pledge/err.out
@@ -10,6 +10,6 @@ Platform: [WILDLINE]
 Version: [WILDLINE]
 Args: [[WILDLINE], "test", "main.js"]
 [WILDCARD]
-thread 'tokio-runtime-worker' panicked at [WILDLINE]
+thread 'tokio-runtime-worker' ([WILDCARD]) panicked at [WILDLINE]
 pledge test permissions called before restoring previous pledge
 note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace