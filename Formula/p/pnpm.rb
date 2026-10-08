class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://ghfast.top/https://github.com/pnpm/pnpm/archive/refs/tags/v12.10.1.tar.gz"
  sha256 "397c34bc0b6b17f2aacdbd13a1264a1cd93faadce68eafa0ef9056fdfc565960"
  license "MIT"
  compatibility_version 1
  head "https://github.com/pnpm/pnpm.git", branch: "main"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "14cd6e677821bd2d97ce9eb4bc353c4fe21e9a028099be80f8104e45ce542db7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4abbb3a54b02aa27e4d0aa0addf7165350a3713e669b8b6025a452bb4d3ebdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "24d27ffa65c36da462cdc06a5954d38b25dd59d24e21d71c33b1842981775020"
    sha256 cellar: :any,                 arm64_linux:       "8f297c950c8444981f66ba1ef4f249dcee81dc94e0f1e5e850eb0e5b3aff32d2"
    sha256 cellar: :any,                 x86_64_linux:      "2bbec4adb031c89efb50c04b3ee6114fa425c68795dd4dc13da6574617b1bf73"
  end

  depends_on "esbuild" => :build
  depends_on "node" => :build
  depends_on "rust" => :build

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  deny_network_access!

  def fetch
    rm ".cargo/config.toml"
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "pnpm/esm-loader" do
      inreplace "package.json" do |s|
        s.gsub! '"enhanced-resolve": "catalog:"', '"enhanced-resolve": "5.26.0"'
        s.gsub! '"esbuild": "catalog:"', "\"esbuild\": \"#{Formula["esbuild"].version}\""
      end
      system "npm", "install", "--workspaces=false", "--omit=optional",
                    *std_npm_args(prefix: false)
    end
  end

  def install
    ENV["ESBUILD_BINARY_PATH"] = formula_opt_bin("esbuild")/"esbuild"
    system "node", "pnpm/esm-loader/scripts/bundle-runtime.mjs"

    system "cargo", "install", *std_cargo_args(path: "pnpm/crates/cli")

    # Upstream ships these beside the binary as shell scripts rather than
    # symlinks: the `dlx` injection for `pnpx`/`pnx` matches on the name of
    # the resolved `current_exe`, which a symlink would report as `pnpm`.
    { "pn" => [], "pnpx" => ["dlx"], "pnx" => ["dlx"] }.each do |name, args|
      (bin/name).write_env_script opt_bin/"pnpm", *args, {}
    end

    generate_completions_from_executable(bin/"pnpm", "completion")
  end

  test do
    # `pnpm init` writes a `packageManager` pin naming this exact pnpm, and
    # every later invocation resolves that pin against the registry, so
    # anything that must run without network has to come first.
    assert_match version.to_s, shell_output("#{bin}/pn --version")

    system bin/"pnpm", "init"
    assert_path_exists testpath/"package.json", "package.json must exist"
  end
end