class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.7.7.tar.gz"
  sha256 "927b797cacdadd67a470a5ed4bef8371ef06dcdf0cb7e56e80f4063a4dcfeb8c"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7df85269ee02f904761e2015e91f8ab8cbe15f00c6261bea593b8ab4700f9441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc2587819ff8af1c651e594e9615486a98b1f7d2a210a6231b87ebfdcf81c18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a909759f974c6f135c74b7ff47e5b5e45475c7ef0ef39155c3a67589abfaa946"
    sha256                               sonoma:        "d0b1b6b32875db7cc5c14389e7d603562841e17cc17953ea87fbb7c1e537b8c6"
    sha256                               ventura:       "95256b1a09479980840867dc5029a003ed80cb93856f695472150e2777ddecde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae3e7dad056b8ed6c98c384c7824215c03f92ced6ae8ee370f6ecfac84043e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8473c9e8e4a43b4cc0e2f3c2a0e02a8ae6fdb8cfb3db1a611df95b16a2c5eec1"
  end

  depends_on "deno" => :build

  # upstream pr ref, https://github.com/fedify-dev/fedify/pull/305
  patch :DATA

  def install
    # upstream bug report, https://github.com/fedify-dev/fedify/issues/303
    odie "Remove `--no-check` workarounds" if build.stable? && version > "1.7.7"

    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--no-check", "--output=#{bin/"fedify"}", "cli/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")
  end

  test do
    # Skip test on Linux CI due to environment-specific failures that don't occur in local testing.
    # This test passes on macOS CI and all local environments (including Linux).
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    version_output = shell_output "NO_COLOR=1 #{bin}/fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end

__END__
diff --git a/fedify/deno.json b/fedify/deno.json
index b3137ad..1d32f20 100644
--- a/fedify/deno.json
+++ b/fedify/deno.json
@@ -65,7 +65,7 @@
     "!vocab/vocab.ts"
   ],
   "tasks": {
-    "codegen": "deno run --allow-read --allow-write --check codegen/main.ts vocab/ ../runtime/ > vocab/vocab.ts && deno fmt vocab/vocab.ts && deno cache vocab/vocab.ts && deno check vocab/vocab.ts",
+    "codegen": "deno run --allow-read --allow-write --no-check codegen/main.ts vocab/ ../runtime/ > vocab/vocab.ts && deno fmt vocab/vocab.ts && deno cache vocab/vocab.ts && deno check vocab/vocab.ts",
     "check-version": "deno run --allow-read=package.json scripts/check_version.ts && deno run ../cli/scripts/check_version.ts",
     "sync-version": "deno run --allow-read=package.json --allow-write=package.json scripts/sync_version.ts && deno run --allow-read=../cli/deno.json --allow-write=../cli/deno.json ../cli/scripts/sync_version.ts",
     "cache": {
diff --git a/fedify/vocab/type.ts b/fedify/vocab/type.ts
index 6be730b..5c25c15 100644
--- a/fedify/vocab/type.ts
+++ b/fedify/vocab/type.ts
@@ -89,7 +89,10 @@ export function getTypeId(
 export function getTypeId(
   object: Object | Link | undefined | null,
 ): URL | undefined | null {
-  if (object == null) return object;
+  // TODO: Deno 2.4.2's TypeScript doesn't properly narrow the type with `object == null` check,
+  // so we need an explicit type assertion here. This should be revisited when upgrading
+  // to newer versions that might fix this type narrowing issue.
+  if (object == null) return object as undefined | null;
   const cls = object.constructor as
     & (new (...args: unknown[]) => Object | Link)
     & {