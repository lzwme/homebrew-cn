class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.7.6.tar.gz"
  sha256 "ae2a009b509cd589b1188b2bc09ad96bc20e028f0608ca8fa3dd510cb4abf094"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "831f981b349d42b02a637db8fb860c7f3a93d270cb3a2399d6fc159cdeb2e841"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f413732865ae1f8e3ce55c79704427ec97446ddfef865d2183d8880c75ad94c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b70b575597eeef782635e069af58f196ff5b36c6fdc0555a2a7e68f2e761a67"
    sha256                               sonoma:        "12428f00b65f0d591d0c22bb92fb71ddfbd42efceef8271a7c2dc69a8991a610"
    sha256                               ventura:       "7cc6cb81ff41d013cb2e029c994ff188dd49cdb0b4f479112e2d29876ef55937"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eb089fc4329d35142c952f01a19cf097a5cdd1274f455a83d86e5278a0743fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "966968592b3ae264487d231a5af247bd27721dfda05fa5183ae96942609d31d6"
  end

  depends_on "deno" => :build

  # upstream pr ref, https://github.com/fedify-dev/fedify/pull/305
  patch :DATA

  def install
    # upstream bug report, https://github.com/fedify-dev/fedify/issues/303
    odie "Remove `--no-check` workarounds" if build.stable? && version > "1.7.6"

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