class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://ghfast.top/https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "120f0fa6383eabd63a9d6f8dd578d393259d2efb81a4318c8222b1ed0ee03c87"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "65b7e0349efb3bb83cacd24b9853c4633b6be7fd771b9d1c7b11880cb7031cd7"
    sha256 cellar: :any, arm64_sequoia: "28300b9b613593dc411395b784ce031cfa6213f2d320bed85fc9d9e6a1ce484e"
    sha256 cellar: :any, arm64_sonoma:  "3d82e71a7f642368cb38f5ae516d3fbf2a8f6e1dfe84d13fafd45bb34408940c"
    sha256 cellar: :any, sonoma:        "7523473fea2c0abd0682fcb9c3e947198e91f2221476bbab2e9d8c0b5a11adbe"
    sha256               arm64_linux:   "eb0739390134d30844942d20ae73cbc00004ff80a93e4a21e4e55bccab33afe3"
    sha256               x86_64_linux:  "f56358a6aaa239fa2a02b13fc8d441aa2cfabf51f7adab4859b28fcb358393de"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pnpm" => :build
  depends_on "rustup" => :build # TODO: try to restore stable rust: https://github.com/voidzero-dev/vite-task/commit/db99ba4d5d33323cc9e7b329f11bdea0610fbc7f
  depends_on "node"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "f09947ab017d6df74299f691853dcfc4f4f0f86e"
    version "f09947ab017d6df74299f691853dcfc4f4f0f86e"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "a477454442eff649b430f9e3c6caf2500fcb7183"
    version "a477454442eff649b430f9e3c6caf2500fcb7183"

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

    ENV["NPM_CONFIG_MANAGE_PACKAGE_MANAGER_VERSIONS"] = "false"

    system "just", "build"
    system "cargo", "install", *std_cargo_args(path: "crates/vite_global_cli")

    system "pnpm", "--filter=vite-plus", "deploy", "--prod", "--legacy", "--no-optional",
           prefix/"node_modules/vite-plus"
    node_modules = prefix/"node_modules/vite-plus/node_modules"
    rm_r node_modules.glob(".pnpm/*/node_modules/*/prebuilds/{darwin,ios}-x64*")
    rm_r node_modules.glob(".pnpm/fsevents@*/node_modules/fsevents")

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