class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://ghfast.top/https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "ac2c2d10ab76eaf4bf2daf923e9fa9d467ca6c0e6542b94dc1afa54fad3ede32"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ae6a9a2792e5ec1372f59fa6515e7d181526410e8431c59208d086e4d8f7a2bb"
    sha256 cellar: :any, arm64_tahoe:       "dd58724ac4e69a95d0f906c60cdc508ed968abd8ecd5f2062116651022d39d75"
    sha256 cellar: :any, arm64_sequoia:     "aefe569c0c59b28d2da46463b247456687e9cb045856019b2c7722b2aacd3f88"
    sha256               arm64_linux:       "d12402d53f0eb50b77562014099b2833b06fc4c713b90af94963a9bd92a8c71d"
    sha256               x86_64_linux:      "8b32a1d06fd0331201dae239069ce0dc67aa01611a9ffb28ae8839c7a435e385"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "node"
  depends_on "sqlite"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "f7de35f45bcd4cb8e4b6d8d11e74fbfb20b03127"
    version "f7de35f45bcd4cb8e4b6d8d11e74fbfb20b03127"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "b6c20f6a8126d8561891e5fb9368e8fc9da37538"
    version "b6c20f6a8126d8561891e5fb9368e8fc9da37538"

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

    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["RUSTC_BOOTSTRAP"] = "1" # workaround to build with stable rust

    # Build with Homebrew pnpm. The staged resources pin their own versions too
    %w[package.json rolldown/package.json vite/package.json].each do |file|
      package_json = buildpath/file
      package_json.atomic_write(JSON.pretty_generate(JSON.parse(package_json.read).except("packageManager")))
    end

    # Align the staged Vite's Vitest versions with the lockfile, as upstream CI does
    system "node", "packages/tools/src/vendored-vitest.ts"

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
    # Use Homebrew node and skip the first-run setup prompt, which stops `vp` on the test PTY
    ENV["VP_NODE_MANAGER"] = "no"

    assert_match version.to_s, shell_output("#{bin}/vp --version")

    # `vp` calls `tcsetattr` on a tty stdin, which stops it with SIGTTOU on the test PTY
    system "#{bin}/vp create vite:application --no-interactive --directory test-app < /dev/null"
    assert_path_exists testpath/"test-app/package.json"

    cd testpath/"test-app" do
      output = shell_output("#{bin}/vp fmt < /dev/null")
      assert_match "Finished", output
    end
  end
end