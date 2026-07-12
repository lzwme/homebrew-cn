class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://ghfast.top/https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "a7ecb52e83feb0f181f068df41196d48fd30fd363d2faf550d280ca4abfe5185"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd53e30679dd750bf1636cfc4ac8c43d66e3f586c104cd27f8a12d0b9a03567d"
    sha256 cellar: :any, arm64_sequoia: "137415c142dd99705b8528e28e7a57f103078ff5fd78d6e12a0640663ecbf41b"
    sha256 cellar: :any, arm64_sonoma:  "d34b1e5894fd32ede8cebbf22381fdd941837f51bfba00e0a29ca6d3267c7841"
    sha256 cellar: :any, sonoma:        "d65e14d4a1a6d036c6e11d420acbec0c6b95cf48e2098021510eb91a1cab3d7e"
    sha256               arm64_linux:   "3fab748e0f0789eb85e5901a6d76f3b7c9a2b84b50658f556321b0b73380ce12"
    sha256               x86_64_linux:  "8b4e7bb3bba7ef6ff268ea57281eff4b5daffa4f56019c3697b04c737c424a6f"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pnpm" => :build
  depends_on "rustup" => :build # TODO: try to restore stable rust: https://github.com/voidzero-dev/vite-task/commit/db99ba4d5d33323cc9e7b329f11bdea0610fbc7f
  depends_on "node"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "6cbd2330dc5ca973b90444973ee04c2dc7ee2f2d"
    version "6cbd2330dc5ca973b90444973ee04c2dc7ee2f2d"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "578ffb80d46940f3b99cd96ed609f8b3a0ac5ede"
    version "578ffb80d46940f3b99cd96ed609f8b3a0ac5ede"

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