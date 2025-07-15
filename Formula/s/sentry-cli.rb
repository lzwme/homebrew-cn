class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.47.1.tar.gz"
  sha256 "d70592fbe44a07f9c6ea839c8b97eae55856550adf4f9c049d9503cc347f6d49"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09896ee751be5b7d11a380be1bea225acce178114c798645b1a7ec1ba41cf781"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e6e77f621ec8fc112b31db1b3f569c36e1e4d9e5dbe3f8a6845e5e289ef6ade"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f444624e7b84519b45666f510e8ba998a96ec664b11de99b66f680728e1342d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0758f174ae00c23ceb45ea15b3dcf1d42b0c1e9830c5a6ed607cd26968921295"
    sha256 cellar: :any_skip_relocation, ventura:       "1ca5e72e4f82cb5c405c95b6b5ee5d37bb668274fa14744181ed351b0863da03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4b1c85e5f20f83549839def333022fea02c9f6991e8a5c8b26dd050c98ddbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4165c35d0739e3dedbe0e0b0fb2bc10e6b8b4fa43eaa87f0e49c4cd47c22c29b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

  on_linux do
    depends_on "openssl@3"
  end

  # Allow setting environment variable to disable swift sandbox.
  # Upstreamed at https://github.com/getsentry/sentry-cli/pull/2587.
  patch :DATA

  def install
    ENV["SWIFT_DISABLE_SANDBOX"] = "1"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end

__END__
diff --git i/apple-catalog-parsing/build.rs w/apple-catalog-parsing/build.rs
index a381d4c8..2a1027be 100644
--- i/apple-catalog-parsing/build.rs
+++ w/apple-catalog-parsing/build.rs
@@ -22,19 +22,30 @@ fn main() {
 
     let out_dir = env::var("OUT_DIR").expect("OUT_DIR is set for build scripts");
 
+    let scratch_path = format!("{out_dir}/swift-scratch");
+    let triple = format!("{arch}-apple-macosx10.12");
+    let mut args = vec![
+        "build",
+        "-c",
+        "release",
+        "--package-path",
+        "native/swift/AssetCatalogParser",
+        "--scratch-path",
+        &scratch_path,
+        "--triple",
+        &triple,
+    ];
+
+    // Allow swift to be run with `--disable-sandbox` in case cargo has been invoked inside a
+    // sandbox already. Nested sandboxes are not allowed on Darwin.
+    println!("cargo:rerun-if-env-changed=SWIFT_DISABLE_SANDBOX");
+    if std::env::var_os("SWIFT_DISABLE_SANDBOX").map_or(false, |s| s != "0") {
+        args.push("--disable-sandbox");
+    }
+
     // Compile Swift code
     let status = Command::new("swift")
-        .args([
-            "build",
-            "-c",
-            "release",
-            "--package-path",
-            "native/swift/AssetCatalogParser",
-            "--scratch-path",
-            &format!("{out_dir}/swift-scratch"),
-            "--triple",
-            &format!("{arch}-apple-macosx10.12"),
-        ])
+        .args(&args)
         .status()
         .expect("Failed to compile SPM");