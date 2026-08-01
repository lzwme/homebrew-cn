class VitePlus < Formula
  desc "Unified toolchain and entry point for web development"
  homepage "https://viteplus.dev"
  url "https://ghfast.top/https://github.com/voidzero-dev/vite-plus/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "15da370f49780414299547f9098c721479dae43fc08fd22ac306e8120a90711c"
  license "MIT"
  head "https://github.com/voidzero-dev/vite-plus.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "34ed8554325aaee298a0bdce5f009365452e2fc573c8e72d25ecc64c38b9e50d"
    sha256 cellar: :any, arm64_sequoia: "622738406c802c6404b2e4f3f6ada1cda1d6c27cb0f6704e9a648756f5ed166a"
    sha256 cellar: :any, arm64_sonoma:  "801f510aff1d30bb6e304378a681476970c2916ab7abe339dde701ec72159a93"
    sha256 cellar: :any, sonoma:        "0d3fa0e5851d2c0e47741206ef2b3c198b13c8a04bc7e539c937dbaf45cac6e0"
    sha256               arm64_linux:   "47fd5307b27302972345090b0ba4243b822f4fb2459232af6f4dd2a99cdda446"
    sha256               x86_64_linux:  "8fa4c40d4979d137ff38103b5927d979d8a094b55249c7204efeaf08f947dcda"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "pnpm" => :build
  depends_on "rustup" => :build # TODO: try to restore stable rust: https://github.com/voidzero-dev/vite-task/commit/db99ba4d5d33323cc9e7b329f11bdea0610fbc7f
  depends_on "node"

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown.git",
        revision: "03e1e3422cd85495c9863ff3bc3b24212d9f4be2"
    version "03e1e3422cd85495c9863ff3bc3b24212d9f4be2"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/voidzero-dev/vite-plus/refs/tags/v#{LATEST_VERSION}/packages/tools/.upstream-versions.json"
      strategy :json do |json|
        json.dig("rolldown", "hash")
      end
    end
  end

  resource "vite" do
    url "https://github.com/vitejs/vite.git",
        revision: "5e7fe129a4dde4f41934083b25e490059985f4e6"
    version "5e7fe129a4dde4f41934083b25e490059985f4e6"

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