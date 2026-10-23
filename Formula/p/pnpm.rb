class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://ghfast.top/https://github.com/pnpm/pnpm/archive/refs/tags/v12.15.0.tar.gz"
  sha256 "a4e58c4bc5113d4539463a7f65708032f7dc8b8b6c4106675c8e2a7e08c754b8"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "267f29b57e80810e1da845f21d0930631fe1d5a4da176a976979bc25b3ea4da6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "530fe5d808b4f086de865fcff1b3c3f6a63ad02768b1fed10204e5be888dad87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3051217f999f5ca6e562990e67d809cce0bc4bd8b76e2756d7af62efc255204f"
    sha256 cellar: :any,                 arm64_linux:       "0bbbcb545f73215c744d1527cda4fc41856ae90c4d713a1fde49f338f449f48a"
    sha256 cellar: :any,                 x86_64_linux:      "f91b343943d0630e348d8d2e9a0d36e22696d8742fbd175b1b8621ee3e168bc4"
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