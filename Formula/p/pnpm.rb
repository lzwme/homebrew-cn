class Pnpm < Formula
  desc "Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://ghfast.top/https://github.com/pnpm/pnpm/archive/refs/tags/v12.9.1.tar.gz"
  sha256 "2825644fb41a3d8135e877ae67ab435a8f6d2b4fe40390f3b2a3534d7e69c565"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7be246eb12095441b8042a8bae16795cbdd9d63d69f00b6097fa720c619a5b84"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "379b827971db6a33f292530ef2ad94e3448439b9723ca625f9ac965482f76624"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1d9e3e023853ae0c83bde79d3158120a49eaa20eb682364dc606c6a808f63dd"
    sha256 cellar: :any,                 arm64_linux:       "7ae50f5685c5cce5d3e25700aa1cade7c1258748a3c26e650a9f9d62fceae4b4"
    sha256 cellar: :any,                 x86_64_linux:      "7123b8ddf5637980ca5f2b46e47af15bcdbbe6277eaf68f020b975f65a8d9d6e"
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