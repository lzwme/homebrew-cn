class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://ghfast.top/https://github.com/pnpm/pnpm/archive/refs/tags/v12.8.1.tar.gz"
  sha256 "d4dabd7621113ed796d5c5acc972d6c48eea722fe83bac16ac3d9043b3dae1ae"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff0286b282db929c24136b8828c59b9bf6da151c35da7f0fad6f95b58e880255"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ecb54af383388ffa34a71543255ddd93ba4c894a695a6b2f723cee82ecb530b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a2e6fcfc8792de166200c32719ec36fa6c03ed2c8d88c74474524e3eca6df8e"
    sha256 cellar: :any,                 arm64_linux:       "70c28a06af424abf22f5dee45661c306110bec193bc2c871b78ab856121db665"
    sha256 cellar: :any,                 x86_64_linux:      "0f8fd805942f4b32a481707a3bb60b27db628652ad9d5ac2ac87296edcf72177"
  end

  depends_on "rust" => :build

  conflicts_with "corepack", because: "both install `pnpm` and `pnpx` binaries"

  deny_network_access!

  def fetch
    rm ".cargo/config.toml"
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
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