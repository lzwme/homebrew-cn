class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://ghfast.top/https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "0cc878005ec54ed43ed40332144afb091efeb2c4dfacfacca23cc2f51b3b5946"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bc73d8da408bcac857549f50dcdbaefaa9b8496ea146320d575bf1cf021d39d7"
    sha256 cellar: :any, arm64_tahoe:       "99bdcb2b508cd302980c04f6bf0327821c4f1651189d997deae4c5a15ba33e07"
    sha256 cellar: :any, arm64_sequoia:     "97fdd38f1a9e09e59f8bcd9334be0d55194160a2c43224d63fa6babab404da12"
    sha256 cellar: :any, arm64_sonoma:      "bfb779ca2b922223269ad3d6e812c728479c92172d8bb28805710bb867ee75e1"
    sha256               arm64_linux:       "f58be36d5cf087ee4acfd3b98a70cfa14d3040f71e213de3737f16d8198cdbc8"
    sha256               x86_64_linux:      "fda736aada80f253386ff01119f1ea7b8e4761bee7e33a690fa18d87a8788dd9"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pnpm" => :build
  depends_on "rustup" => :build # TODO: try to restore stable rust: https://github.com/voidzero-dev/vite-task/commit/db99ba4d5d33323cc9e7b329f11bdea0610fbc7f
  depends_on "node"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "26b4c6e56c5553d72a910d0f73d60fa331c0ed88"
    version "26b4c6e56c5553d72a910d0f73d60fa331c0ed88"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "de1111ab0be00879b404e7ed3b2a80e264edddc1"
    version "de1111ab0be00879b404e7ed3b2a80e264edddc1"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("vite", "hash")
      end
    end
  end

  def install
    resource("rolldown").stage buildpath/"rolldown"
    resource("vite").stage buildpath/"vite"

    # Build with Homebrew pnpm. The staged resources pin their own versions too
    %w[package.json rolldown/package.json vite/package.json].each do |file|
      package_json = buildpath/file
      package_json.atomic_write(JSON.pretty_generate(JSON.parse(package_json.read).except("packageManager")))
    end

    # Vite patches only build-time dependencies, which the production deploy below omits
    (buildpath/"pnpm-workspace.yaml").append_lines "allowUnusedPatches: true"

    system "just", "build"
    system "cargo", "install", *std_cargo_args(path: "crates/vp_global_cli")

    system "pnpm", "--filter=vite-plus", "deploy", "--prod", "--legacy", "--no-optional",
           prefix/"node_modules/vite-plus"
    node_modules = prefix/"node_modules/vite-plus/node_modules"
    # Remove incompatible pre-built `bare-*` binaries. Recurse as `deploy --legacy` writes
    # both the legacy `<name>@<version>` and the current `@/<name>/<version>/<hash>` layouts
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob(".pnpm/**/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    rm_r node_modules.glob(".pnpm/**/node_modules/fsevents")

    # Symlink vp to vpr and vpx. These are detected at runtime by argv[0]
    bin.install_symlink bin/"vp" => "vpr"
    bin.install_symlink bin/"vp" => "vpx"

    # Generate shell completions, vp uses clap but with a custom env var so we can't use our helper
    (bash_completion/"vp").write Utils.safe_popen_read({ "VP_COMPLETE" => "bash" }, bin/"vp")
    (fish_completion/"vp.fish").write Utils.safe_popen_read({ "VP_COMPLETE" => "fish" }, bin/"vp")
    (zsh_completion/"_vp").write Utils.safe_popen_read({ "VP_COMPLETE" => "zsh" }, bin/"vp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vp --version")

    system bin/"vp", "create", "vite:application", "--no-interactive", "--directory", "test-app"
    assert_path_exists testpath/"test-app/package.json"

    cd testpath/"test-app" do
      output = shell_output("#{bin}/vp fmt")
      assert_match "Finished", output
    end
  end
end